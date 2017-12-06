#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char **argv)
{
    for (int i = 0; i < argc; i++)
        printf("%s\n", argv[i]);

    if (argc < 2) {
        fprintf(stderr, "Must include a rom to convert.\n");
        exit(1);
    }

    FILE *rom = fopen(argv[1], "r");
    if (rom == NULL) {
        fprintf(stderr, "Error opening file %s\n", argv[1]);
        exit(1);
    } else {
        printf("rom opened\n");
    }

    char new_rom_name[256] = "\0";
    strcpy(new_rom_name, argv[1]);
    strcat(new_rom_name, "_FPGA.coe");
    FILE *fpga_rom = fopen(new_rom_name, "w");
    if (fpga_rom == NULL) {
        fprintf(stderr, "Error creating file %s\n", new_rom_name);
        exit(1);
    } else {
        printf("New rom opened\n");
    }

    unsigned char characters[] = {
	0xF0, 0x90, 0x90, 0x90, 0xF0,
	0x20, 0x60, 0x20, 0x20, 0x70,
	0xF0, 0x10, 0xF0, 0x80, 0xF0,
	0xF0, 0x10, 0xF0, 0x10, 0xF0,
	0x90, 0x90, 0xF0, 0x10, 0x10,
	0xF0, 0x80, 0xF0, 0x10, 0xF0,
	0xF0, 0x80, 0xF0, 0x90, 0xF0,
	0xF0, 0x10, 0x20, 0x40, 0x40,
	0xF0, 0x90, 0xF0, 0x90, 0xF0,
	0xF0, 0x90, 0xF0, 0x10, 0xF0,
	0xF0, 0x90, 0xF0, 0x90, 0x90,
	0xE0, 0x90, 0xE0, 0x90, 0xE0,
	0xF0, 0x80, 0x80, 0x80, 0xF0,
	0xE0, 0x90, 0x90, 0x90, 0xE0,
	0xF0, 0x80, 0xF0, 0x80, 0xF0,
	0xF0, 0x80, 0xF0, 0x80, 0x80};

    fprintf(fpga_rom, "memory_initialization_radix=16;\nmemory_initialization_vector=");
    int i = 0;
    for (; i < 80; i++)
	fprintf(fpga_rom, "%02x ", characters[i]);

    for (; i < 511; i++)
	fprintf(fpga_rom, "00 ");

    fprintf(fpga_rom, "00");
    uint8_t c;
    fpos_t pos;
    fpos_t file_end;
    fseek(rom, 0, SEEK_END);
    fgetpos(rom, &file_end);
    rewind(rom);
    for (i = 0; i < file_end; i++) {
        fseek(rom, i, SEEK_SET);
        fgetpos(rom, &pos);
        printf("pos = %d\n", pos);
        c = fgetc(rom);
        if (feof(rom))
            fprintf(fpga_rom, " 1a");
        else
            fprintf(fpga_rom, " %02x", c);
    }
    fprintf(fpga_rom, ";\n");
    fflush(fpga_rom);

    fclose(rom);
    fclose(fpga_rom);

    printf("DONE!");

    return 0;
}
