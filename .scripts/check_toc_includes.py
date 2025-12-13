import argparse
import os

import defusedxml.ElementTree as ET

base_dir = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "BeaconUnitFrames"
)


def get_all_lua_files(base_dir, ignore_files):
    """Get all Lua files in the addon directory, excluding test directories"""
    lua_files = set()

    for root, _dirs, files in os.walk(base_dir):
        # Skip test directories
        if "_spec" in root or "test" in root.lower():
            continue

        for file in files:
            if file.endswith(".lua"):
                # Get relative path from base_dir
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, base_dir)
                # Normalize path separators for consistency
                rel_path = rel_path.replace("\\", "/")
                if rel_path in ignore_files:
                    print(f"⚠️  Ignoring Lua file: {rel_path}")
                    continue
                lua_files.add(rel_path)

    return lua_files


def parse_toc_file(toc_path, ignore_files):
    """Parse TOC file and return list of files that are included"""
    included_files = []

    with open(toc_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            # Skip comments and empty lines
            if not line or line.startswith("##"):
                continue

            # Skip build directives
            if line.startswith("#@"):
                continue

            if line in ignore_files:
                print(f"⚠️  Ignoring TOC include: {line}")
                continue

            included_files.append(line)

    return included_files


def parse_xml_file(xml_path):
    """Parse XML file and return list of script files and included XML files"""
    script_files = []
    include_files = []

    try:
        # Read and parse XML content, handling namespace issues
        with open(xml_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Handle namespace declaration issues in WoW XML files
        # Replace xsi:schemaLocation with proper namespace declaration
        if "xsi:schemaLocation" in content and "xmlns:xsi" not in content:
            content = content.replace(
                "<Ui xsi:schemaLocation",
                '<Ui xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation',
            )

        # Parse the fixed content
        root = ET.fromstring(content)

        # Handle namespace if present
        if root.tag.startswith("{"):
            namespace = {"ns": root.tag.split("}")[0].strip("{")}
            script_elements = root.findall("ns:Script", namespace) + root.findall(
                ".//ns:Script", namespace
            )
            include_elements = root.findall("ns:Include", namespace) + root.findall(
                ".//ns:Include", namespace
            )
        else:
            # No namespace - search for elements directly
            script_elements = root.findall("Script") + root.findall(".//Script")
            include_elements = root.findall("Include") + root.findall(".//Include")

        # Extract script files
        for script in script_elements:
            file_attr = script.get("file")
            if file_attr:
                # Normalize path separators
                file_attr = file_attr.replace("\\", "/")
                script_files.append(file_attr)

        # Extract include files
        for include in include_elements:
            file_attr = include.get("file")
            if file_attr:
                # Normalize path separators
                file_attr = file_attr.replace("\\", "/")
                include_files.append(file_attr)

    except (ET.ParseError, IOError) as e:
        print(f"Error parsing XML file {xml_path}: {e}")

    return script_files, include_files


def walk_includes(
    base_dir, file_path, included_lua_files, ignore_files=None, processed_files=None
):
    """Recursively walk through include/import tree and track Lua files"""
    if processed_files is None:
        processed_files = set()
    if ignore_files is None:
        ignore_files = set()

    # Normalize path
    file_path = file_path.replace("\\", "/")

    # Avoid infinite loops
    if file_path in processed_files:
        return
    processed_files.add(file_path)

    # Check if this XML file should be ignored
    if file_path in ignore_files:
        if file_path.endswith(".xml"):
            print(f"⚠️  Ignoring XML file and includes: {file_path}")
        else:
            print(f"⚠️  Ignoring file: {file_path}")
        return

    full_path = os.path.join(base_dir, file_path)

    if not os.path.exists(full_path):
        print(f"⚠️  Warning: File not found: {file_path}")
        return

    if file_path.endswith(".lua"):
        # This is a Lua file, add it to our included set
        included_lua_files.add(file_path)

    elif file_path.endswith(".xml"):
        # This is an XML file, parse it for more includes
        script_files, include_files = parse_xml_file(full_path)

        # Get the directory of the current XML file for relative path resolution
        xml_dir = os.path.dirname(file_path)

        # Process script files
        for script_file in script_files:
            if xml_dir:
                script_path = f"{xml_dir}/{script_file}"
            else:
                script_path = script_file
            script_path = script_path.replace("\\", "/")
            included_lua_files.add(script_path)

        # Recursively process included XML files
        for include_file in include_files:
            if xml_dir:
                include_path = f"{xml_dir}/{include_file}"
            else:
                include_path = include_file
            walk_includes(
                base_dir,
                include_path,
                included_lua_files,
                ignore_files,
                processed_files,
            )


def check_toc_includes(ignore_files=None):
    """Main function to check TOC includes"""
    if ignore_files is None:
        ignore_files = set()

    toc_path = os.path.join(base_dir, "BeaconUnitFrames.toc")

    if not os.path.exists(toc_path):
        print(f"TOC file not found: {toc_path}")
        return

    # Get all Lua files in the addon directory
    all_lua_files = get_all_lua_files(base_dir, ignore_files)
    print(
        f"\nℹ️  Found {len(all_lua_files)} Lua files (after ignores) in addon directory"
    )

    # Parse TOC file to get initial includes
    toc_includes = parse_toc_file(toc_path, ignore_files)
    print(f"\nℹ️  Found {len(toc_includes)} includes (after ignores) in TOC file")

    # Track included Lua files
    included_lua_files = set()

    # Walk through each include in the TOC
    for include_file in toc_includes:
        walk_includes(base_dir, include_file, included_lua_files, ignore_files)

    print(
        f"\nℹ️  Found {len(included_lua_files)} / {len(all_lua_files)} Lua files included in TOC tree"
    )

    # Find missing files (Lua files not included in TOC tree)
    missing_files = all_lua_files - included_lua_files

    # Find extra includes (files referenced in TOC tree but don't exist)
    extra_includes = included_lua_files - all_lua_files

    # Print results
    if missing_files:
        print("\n❌ Lua files NOT included in TOC tree:")
        for file in sorted(missing_files):
            print(f"  {file}")

    if extra_includes:
        print("\n⚠️  Files referenced in TOC tree but don't exist:")
        for file in sorted(extra_includes):
            print(f"  {file}")

    if not missing_files and not extra_includes:
        print("\n✅ All Lua files are properly included in the TOC tree!")

    # Print summary
    print("\nSummary:")
    print(f"  Total Lua files in addon: {len(all_lua_files)}")
    print(f"  Lua files included in TOC: {len(included_lua_files)}")
    print(f"  Missing from TOC: {len(missing_files)}")
    print(f"  Extra references: {len(extra_includes)}")

    return len(missing_files) == 0 and len(extra_includes) == 0


def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="Check TOC file includes and find missing or extra Lua files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python check_toc_includes.py
  python check_toc_includes.py --ignore embeds.xml
  python check_toc_includes.py --ignore embeds.xml --ignore unitFrames/dummyFrame/index.xml
        """,
    )

    parser.add_argument(
        "--ignore",
        action="append",
        dest="ignore_files",
        default=[],
        help="Files to ignore during parsing (can be used multiple times)",
    )

    return parser.parse_args()


if __name__ == "__main__":
    args = parse_arguments()

    # Convert ignore list to set and normalize paths
    ignore_files = set()
    for xml_file in args.ignore_files:
        normalized_path = xml_file.replace("\\", "/")
        ignore_files.add(normalized_path)

    if ignore_files:
        files = "\n  ".join(sorted(ignore_files))
        print(f"\nℹ️  Ignoring {len(ignore_files)} files:\n  {files}")

    success = check_toc_includes(ignore_files)
    exit(0 if success else 1)
