#include "A.h"
#include "B.h"

#include <iostream>

int main(int argc, char* argv[])
{
    A a;
    B b;
    
    for ( int i = 1; i < argc; ++i)
    {
        std::cout << "argv[" << i << "]=" << argv[i] << std::endl;
    }
    std::cout << "A: " << a.str() << std::endl;
    std::cout << "B: " << b.str() << std::endl;
}

