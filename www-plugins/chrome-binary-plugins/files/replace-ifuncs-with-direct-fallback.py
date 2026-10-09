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
        struct.pack("<QQQ", 0x132BF30, 0x408, 0x11F0EC0): struct.pack(
            "<QQQ", 0x132BF30, 0x403, 0xE56F5C
        ),
        # Relocation 2
        struct.pack("<QQQ", 0x132BF38, 0x408, 0x11F0E5C): struct.pack(
            "<QQQ", 0x132BF38, 0x403, 0xE56F5C
        ),
        # Relocation 3
        struct.pack("<QQQ", 0x132BF40, 0x408, 0x11F0DF8): struct.pack(
            "<QQQ", 0x132BF40, 0x403, 0xE56F5C
        ),
        # Relocation 4
        struct.pack("<QQQ", 0x132BF48, 0x408, 0x11F2ACC): struct.pack(
            "<QQQ", 0x132BF48, 0x403, 0x11F2B50
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
