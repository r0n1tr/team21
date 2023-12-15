#include <iostream>
#include <vector>
#include <fstream> 
#include <sstream>

int main() 
{
    std::ifstream infile("gaussian.mem");

    std::string data;
    int counts[256];

    for (int i = 0; i < 255; i++)
    {
        counts[i] = 0;
    }

    while (infile >> data)
    {
        unsigned int x;   
        std::stringstream ss;
        ss << std::hex << data;
        ss >> x;
        // output it as a signed type
        counts[static_cast<int>(x)]++;       
    }
    
    std::cout << "pdf:" << std::endl;
    
    for (int i = 0; i < 255; i++)
    {
        // std::cout << i << " " << counts[i] << std::endl;
        std::cout << counts[i] << std::endl;
    }
}
   
