#define TOOL_VERSION "1.0.0"

//display the Help if the user enters -h or an invalid argument count
void displayHelp(const char *fn) {

printf("[+] %s [byte size] [offset] [hex to be written] [file]\n",fn);
printf("[+] %s -h : Displays Help\n",fn);
printf("[+] %s -v : Displays Version\n",fn);
printf("[+] %s -c : Displays Credits\n",fn);

}
//display the tool version if -v was entered
void displayVersion(const char *fn) {

printf("[+] %s v%s\n",fn,TOOL_VERSION);

}

//displays the credits, the maker of the program when -c is entered
void displayCredits(const char *fn) {

printf("[+] The Tool '%s' was made by HackJack (@1c0d3)\n",fn);

}

//checks if the program is executed as root
bool isRoot() {
    
    return (getuid() == 0);
}

//####MAIN FUNCTION####

int main(int argc, char **argv, char **envp) {

//check for root
if (!isRoot()) {

printf("You must be root to use %s\n",argv[0]);
return 0;

}

//check if arg 1 is -h
if (strcmp(argv[1],"-h") == 0) {

displayHelp(argv[0]);
return 0;

}

//check if arg 1 is -v
if (strcmp(argv[1],"-v") == 0) {

displayVersion(argv[0]);
return 0;

}

//check if arg 1 is -c
if (strcmp(argv[1],"-c") == 0) {

displayCredits(argv[0]);
return 0;

}

//check if the argument count is 5, if not, display the help
if (argc != 5) {

displayHelp(argv[0]);

return 1;

}
    
//declaring some variables
int byteSize = 0; //bytesize entered by the user
uint16_t num16; //2 byte
uint32_t num32; //4 byte
uint64_t num64; //8 byte
uint offset = 0x0; //offset to write to
const char *filePath = argv[4]; //get the file path as argument 5
FILE *target = fopen(filePath, "r+"); //open the file for reading and updating
sscanf(argv[1], "%d", &byteSize); //read into byteSize
uint8_t hex[byteSize]; //create an array of hex values with the size of byteSize
sscanf(argv[2], "%x", &offset); //read offset

//check if file opening was successful or not
    
if (target == NULL) { //error, file not found or no permissions or something

printf("[-] Error: Could not open File\n");

return 1;

} else { //successful

printf("[+] Opening File for writing\n");

}

switch (byteSize) { //check bytesize of read into the array we created depending on the bytesize


        /*
         
         apply each byte to an array position
         Hex: 0xC046
         array[0] = 0x46
         array[1] = 0xC0
         reversing the bytes entered
         
         */
        
case 2:

sscanf(argv[3], "%hx", &num16); //read into uint16_t
hex[1] = num16;
hex[0] = num16 >> 8;

break;

case 4: 

sscanf(argv[3], "%x", &num32); //read into uint32_t
hex[3] = num32;
hex[2] = num32 >> 8;
hex[1] = num32 >> 16;
hex[0] = num32 >> 24;

break;

case 8: 

sscanf(argv[3], "%llx", &num64); //read into uint64_t
hex[7] = num64;
hex[6] = num64 >> 8;
hex[5] = num64 >> 16;
hex[4] = num64 >> 24;
hex[3] = num64 >> 32;
hex[2] = num64 >> 40;
hex[1] = num64 >> 48;
hex[0] = num64 >> 56;

break;

default:

printf("[-] Error: Invalid Bytesize\n");
return 1;

break;

}
    
//going to the position in the file
if (fseek(target, offset, SEEK_SET) == 0) {

printf("[+] Found Position for writing\n");

}

//writing hex at the position. writing byte by byte
if (fwrite(hex, sizeof(uint8_t), sizeof(hex), target) != sizeof(hex)) {

printf("[-] Error: Writing Failed\n");

}

//outputting success
printf("[+] Patching File\n");

//closing file
    
fclose(target);

printf("[+] Closing File\n");

return 0;
}

// vim:ft=objc
