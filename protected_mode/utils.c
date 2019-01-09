unsigned int strlen(const char* string) {
    unsigned int len = 0;
    while (string[len]) {
        len++;
    };

    return len;
}

char* strchr(const char* string, const char sym) {
    unsigned int i = 0;
    while (string[i]) {
        if (string[i] == sym) {
            return &string[i];
        }
        i++;
    }

    return 0;
}


char* memcpy(char* dest, const char * src, unsigned int size) {
    unsigned int i = 0;
    while(size--) {
        *dest = src[i];
        dest++;
        i++;
    }

    return src;
}

void u16memset(short unsigned int* ptr, short unsigned int fill, unsigned int size) {
    while (size--) {
        *ptr = fill;
        ptr++;
    }
}

void stupid_sleep(const unsigned int ms) {
    for(unsigned int i = 0; i < ms; i++) {
        for(unsigned int j = 0; j < 100000; j++);
    }
}


int state = 0x1337;

int srand(int val) {
    state = val ^ 0xFFFFFFFF;
    for(int i = 0; i < 100; i++) {
        rand();
    }
}

int rand() {
    int tmp = state;
    state = (1103515245 * state + 12345) & 0x7FFFFFFF; // drop last bit, so we are using only 30..0 
    return tmp;
}