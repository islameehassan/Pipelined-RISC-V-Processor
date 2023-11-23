#include <iostream>
#include <fstream>
#include <string>
using namespace std;

// test_case3/test_case3_hext.txt

int main(){
    // TXT FILE SHOULD BE IN THE SAME DIRECTORY

    string test_case;
    std::cout << "Enter test case txt file name(without .txt): ";
    cin >> test_case;

    string filename =  test_case + "_hex" + ".txt";
    ifstream hexfile(filename);

    if(!hexfile.is_open()){
        cout << "Unable to open this file";
        return EXIT_FAILURE;
    }

    string outFileName = test_case + ".hex";
    ofstream outFile(outFileName);

    string line;
    while(getline(hexfile,line)){

        outFile << line.substr(6, 2);
        outFile << '\n';
        outFile << line.substr(4, 2);
        outFile << '\n';
        outFile << line.substr(2, 2);
        outFile << '\n';
        outFile << line.substr(0, 2);
        outFile << '\n';
        
    }


}