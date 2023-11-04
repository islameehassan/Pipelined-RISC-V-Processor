#include <iostream>
#include <fstream>


struct instruction{
    std::string name;
    char type;
};

// list all 40 rv32I instructions here

instruction rv32I_instructions[] = {
    {"lui", 'U'},
    {"auipc", 'U'},
    {"jal", 'J'},
    {"jalr", 'L'},
    {"beq", 'B'},
    {"bne", 'B'},
    {"blt", 'B'},
    {"bge", 'B'},
    {"bltu", 'B'},
    {"bgeu", 'B'},
    {"lb", 'L'},
    {"lh", 'L'},
    {"lw", 'L'},
    {"lbu", 'L'},
    {"lhu", 'L'},
    {"sb", 'S'},
    {"sh", 'S'},
    {"sw", 'S'},
    {"addi", 'I'},
    {"slti", 'I'},
    {"sltiu", 'I'},
    {"xori", 'I'},
    {"ori", 'I'},
    {"andi", 'I'},
    {"slli", 'I'},
    {"srli", 'I'},
    {"srai", 'I'},
    {"add", 'R'},
    {"sub", 'R'},
    {"sll", 'R'},
    {"slt", 'R'},
    {"sltu", 'R'},
    {"xor", 'R'},
    {"srl", 'R'},
    {"sra", 'R'},
    {"or", 'R'},
    {"and", 'R'},
    {"fence", 'Y'},
    {"ecall", 'Y'},
    {"ebreak", 'Y'}
};

std::string regs_name[] = {
    "x0", "x1", "x2", "x3", "x4", "x5", "x6", 
    "x7", "x8", "x9", "x10", "x11", "x12", "x13", 
    "x14", "x15", "x16", "x17", "x18", "x19", "x20", 
    "x21", "x22", "x23", "x24", "x25", "x26", "x27", 
    "x28", "x29", "x30", "x31"
};

void generate_test_cases(int num_instructions){
    freopen("test_cases.txt", "w", stdout);
    // generate test cases here
    for(int i = 0; i < num_instructions; ++i){
        int inst_num = rand()%40;  
        instruction inst = rv32I_instructions[inst_num];
        int rs1 = rand()%32;
        int rs2 = rand()%32;
        int rd = rand()%32;
        int imm = rand() % 100;
        int branch_imm = 4 * (rand()%(num_instructions - i) + 1);   // branch to a random instruction not greater than the last instruction

        if(inst.type == 'R'){
            std::cout << inst.name << " " << regs_name[rd] << ", " << regs_name[rs1] << ", " << regs_name[rs2];
        }
        else if(inst.type == 'I'){
            std::cout << inst.name << " " << regs_name[rd] << ", " << regs_name[rs1] << ", " << imm;
        }
        else if(inst.type == 'S'){
            std::cout << inst.name << " " << regs_name[rs1] << ", " << imm << "(" << regs_name[rs2] << ")";
        }
        else if(inst.type == 'B'){
            std::cout << inst.name << " " << regs_name[rs1] << ", " << regs_name[rs2] << ", " << branch_imm;
        }
        else if(inst.type == 'U'){
            std::cout << inst.name << " " << regs_name[rd] << ", " << imm;
        }
        else if(inst.type == 'J'){
            std::cout << inst.name << " " << regs_name[rd] << ", " << branch_imm;
        }
        else if(inst.type == 'L'){
            std::cout << inst.name << " " << regs_name[rd] << ", " << imm << "(" << regs_name[rs1] << ")";
        }
        else if(inst.type == 'Y'){
            std::cout << inst.name;
        }
        std::cout << '\n';
    }
}

int main(){
    srand(time(NULL));
    int num_instructions;
    std::cout << sizeof(rv32I_instructions) / sizeof(instruction) << std::endl;   
    std::cout << "Enter how many instructions you want to generate: ";
    std::cin >> num_instructions;
    generate_test_cases(num_instructions);
}