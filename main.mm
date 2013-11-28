#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>

using namespace std;

#define TOOL_VERSION "1.1.0"

//display the Help if the user enters -h or an invalid argument count
void displayHelp(const char *fn) {
    
    printf("[+] %s [file] : Start Patching the File\n",fn);
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
    
    printf("[+] The Tool '%s' was made by Jack (@sharedRoutine)\n",fn);
    
}

//checks if the program is executed as root
bool isRoot() {
    
    return (getuid() == 0);
}

//####MAIN FUNCTION####

int main(int argc, char **argv, char **envp) {
    
    //check if the argument count is 2, if not, display the help
    if (argc != 2) {
        
        displayHelp(argv[0]);
        
        return 1;
        
    }
    
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
    
    //reading filepath
    const char *filePath = argv[1]; //get the file path as argument 5
    FILE *target = fopen(filePath, "r+"); //open the file for reading and updating
    
    //check if file opening was successful or not
    
    if (target == NULL) { //error, file not found or no permissions or something
        
        printf("[-] Error: Could not open File\n");
        
        return 1;
        
    } else { //successful
        
        printf("[+] Opening File for writing\n");
        
    }
    
    //asking fo offset and data

    char offsetInput[10];
    printf("[+] Enter the Offset to Patch: ");
    fgets(offsetInput,sizeof(offsetInput),stdin);
    uint32_t offset = 0x0;
    sscanf(offsetInput, "%x", &offset);
    
    char dataInput[50]; //max 50 bytes to be read and later be written
    printf("[+] Enter the Data to write: ");
    fgets(dataInput,sizeof(dataInput),stdin);
    
    string dat = dataInput;
    
    size_t find = dat.find("0x");
    
    if (find != -1) { //check for 0x and remove it if it was put in
        
        dat.replace(find, 2, "");
    }
    
    int len = dat.size(); //get the string length
    
    uint8_t data[len / 2]; //create an array of size bytesize of the string
    
    int x = 0;
    
    //loop through the string and add bytes to the char array to write
    
    for(int i = 0; i < len; i += 2) {
        
        string dat_tmp = dat.substr(i, 2);
        uint8_t tmp;
        sscanf(dat_tmp.c_str(), "%hhx", &tmp);
        data[x] = tmp;
        x++;
        
    }

    //going to the position in the file
    if (fseek(target, offset, SEEK_SET) == 0) {
        
        printf("[+] Found Position for writing: 0x%x\n",offset);
        
    }
    
    //writing hex at the position. writing byte by byte
    if (fwrite((const void *)&data, sizeof(uint8_t), sizeof(data), target) != sizeof(data)) {
        
        printf("[-] Error: Writing Failed\n");
        return 1;
        
    }
    
    //outputting success
    printf("[+] Patching File\n");
    
    //closing file
    
    fclose(target);
    
    printf("[+] Closing File\n");
    
    return 0;
}

// vim:ft=objc