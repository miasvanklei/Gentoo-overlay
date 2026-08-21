import argparse
import struct


def main():
    parser = argparse.ArgumentParser(
        description="Remove ifunc from widevine shared library (may break when updated)."
    )
    parser.add_argument(
        "filename", type=str, help="Path to the input widevine library to be patched"
    )
    parser.add_argument(
        "output_name", type=str, help="Path where widevine library will be saved"
    )
    args = parser.parse_args()

    # Relocation structs to match (Offset, Info, Addend)
    # Info field for R_AARCH64_IRELATIVE (1032) is 0x408
    # Info field for R_AARCH64_RELATIVE (1027) is 0x403
    patches = {
        # Relocation 1
        struct.pack("<QQQ", 0x12F9BB8, 0x408, 0x11F5AA4): struct.pack(
            "<QQQ", 0x12F9BB8, 0x403, 0xE4FC30
        ),
        # Relocation 2
        struct.pack("<QQQ", 0x12F9BC0, 0x408, 0x11F5A40): struct.pack(
            "<QQQ", 0x12F9BC0, 0x403, 0xE4FC30
        ),
        # Relocation 3
        struct.pack("<QQQ", 0x12F9BC8, 0x408, 0x11F59DC): struct.pack(
            "<QQQ", 0x12F9BC8, 0x403, 0xE4FC30
        ),
        # Relocation 4
        struct.pack("<QQQ", 0x12F9BD0, 0x408, 0x11F7010): struct.pack(
            "<QQQ", 0x12F9BD0, 0x403, 0x11F7094
        ),
    }

    try:
        with open(args.filename, "rb") as f:
            data = bytearray(f.read())
    except FileNotFoundError:
        print(f"Error: The file '{args.filename}' could not be found.")
        return
    except PermissionError:
        print(f"Error: Permission denied when reading '{args.filename}'.")
        return

    patched_count = 0
    for old_bytes, new_bytes in patches.items():
        index = data.find(old_bytes)
        if index != -1:
            data[index : index + 24] = new_bytes
            patched_count += 1
        else:
            print("Warning: A relocation pattern could not be found in the binary.")

    try:
        with open(args.output_name, "wb") as f:
            f.write(data)
    except PermissionError:
        print(f"Error: Permission denied when writing to '{args.output_name}'.")
        return

    print(
        f"Successfully patched {patched_count}/4 relocations."
    )


if __name__ == "__main__":
    main()
