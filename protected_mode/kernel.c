#include "utils.h"

#define STR(x) #x
#define STRINGIFY(x) STR(x)
#define panic(reason) __do_panic(reason, __FUNCTION__, __FILE__ ":" STRINGIFY(__LINE__))
#define trail(x) ((80 - (((int)x - 0xb8000) >> 1) % 80))
#define RESET_CAR() (car = 0xb8000)
#define LAST_STR() (car >= (short*)0xb8f00)

#define STR_SIZE 160


#define VGA_PTR         ((short*)0xb8000)

#define BSOD_COLOR      0x1F00
#define DEFAULT_COLOR   0x0F00

short *car = VGA_PTR;


unsigned int strlen(const char*);

void __fill_screen(char color, char symbol) {
    short* vga = (short*) 0xb8000;
    for (int i = 0; i < 80 * 25; i++) {
        vga[i] = (color << 8) | symbol;
    }
}

void clear() {
    __fill_screen(0, ' ');
}


void print_str_with_color(const char* string, short color) {
    int i = 0;
    while (string[i]) {
        if (string[i] == '\t') {
            for (int j = 0; j < 4; j++) {
                *car = color | ' ';
                car++;
            }
        } else if (string[i] == '\n') {
            int rest = trail(car);
            for(int j = 0; j < rest; j++) {
                *car = color | ' ';
                car++;
            }
        } else {
            *car = color | string[i];
            car++;
        }
        i++;
    }
}

void scroll_up_screen(short int is_spec) {
    if (is_spec) {
        u16memset(car, DEFAULT_COLOR | ' ', trail(car));
    } else {
        u16memset(car, DEFAULT_COLOR | ' ', trail(car)-1);
    }
    memcpy(VGA_PTR ,VGA_PTR+80, STR_SIZE * 24);
    u16memset(VGA_PTR+24*80, DEFAULT_COLOR | ' ', 80);
}



void print_str(const char* string) {
    int i = 0;
    while (string[i]) {

        if (string[i] == '\t') {
            if (LAST_STR() && (trail(car) < 4)) {
                scroll_up_screen(1);
                u16memset(car, DEFAULT_COLOR | ' ', 4);
                car = car - 76;
            } else {
                u16memset(car, DEFAULT_COLOR | ' ', 4);
                car+= 4;
            }
        } else if (string[i] == '\n') {
            if (LAST_STR()) {
                scroll_up_screen(1);
                car = car + trail(car) - 80;
            } else {
                int rest = trail(car);
                u16memset(car, DEFAULT_COLOR | ' ', rest);
                car+= rest;
            }
        } else {
            if (LAST_STR() && (trail(car) == 1)) {
                *car = DEFAULT_COLOR | string[i];
                scroll_up_screen(0);
                car = car + trail(car) - 80;
            } else {
                *car = DEFAULT_COLOR | string[i];
                car++;
            }
        }
        i++;
    }
}

void __do_panic(const char* reason, const char* function, const char* loc) {
    __fill_screen(0x10, ' ');
    const short color = 0x1F00;
    short* vga = VGA_PTR;

    // This part is very ugly i know, BUT IRL BSOD LOOKS SO FUCKING COOL
    print_str_with_color("\n\n\n\n\n\n\t\t\t\t\t\t\t\t\t", BSOD_COLOR);
    print_str_with_color("mostikOS", 0xF100);
    print_str_with_color("\n\n\t\t\tA fatal exception has occured in ", BSOD_COLOR);
    print_str_with_color(function, BSOD_COLOR);
    print_str_with_color(" at ", BSOD_COLOR);
    print_str_with_color(loc, BSOD_COLOR);
    print_str_with_color(".\n\t\t\tThe current application will be terminated.\n\t\t\tReason: ", BSOD_COLOR);
    print_str_with_color(reason, BSOD_COLOR);
    print_str_with_color("\n\n\t\t\t*  Press any key to fuck yourself.\n", BSOD_COLOR);
    print_str_with_color("\t\t\t*  Reboot your PC or VM or whatever your running this OS on.\n", BSOD_COLOR);
    print_str_with_color("\t\t\t*  Oylng vqv i cvmqh, anuhln gv rgb qrxbqvy?\n", BSOD_COLOR);
    print_str_with_color("\n\n\t\t\t\t\t\t  Press any key to nothing :)", BSOD_COLOR);
}

extern void kmain() {
    clear();
    // panic("Invalid memory location access");
    print_str("1234567876541234\t\t\t\t\t\t\t\t\t\t\t\t\tHmmm looks weird\n");
    stupid_sleep(1000);
    for(int i = 0; i < 30; i++) {
        // stupid_sleep(100);
        // print_str("asdfadfadsf\n");
        // stupid_sleep(100);
        // print_str("asdfasdf\n");
        // stupid_sleep(100);
        print_str("### 12345678765412\t\t\t\t34123456787 cvmqh, anu\nhln g6541234123456787l\nication will be t2-3-4-1-2-34567876541234 ###");
        stupid_sleep(300);
        // print_str("@#$^&*()(*&^%%$#\n");
        // stupid_sleep(100);
        // print_str("huy\n");
        // stupid_sleep(300);
        // print_str("pizda\n");
    }
}
