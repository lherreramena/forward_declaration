#include "A.h"
#include "B.h"

#include <iostream>

#define PRINT_DBG(a) #a << ":" << a 

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


    auto shA1 = std::make_shared<A>();
    std::shared_ptr<A> shA2;
    //auto pA = shA1.get();
    //shA2.reset(pA);
    shA2 = shA1;
    auto shA3 = shA1;

    std::cout << PRINT_DBG(shA1.get()) << " , " << PRINT_DBG(shA1.use_count()) 
            << " , " << PRINT_DBG(shA2.get()) << " , " << PRINT_DBG(shA2.use_count()) 
            << " , " << PRINT_DBG(shA3.get()) << " , " << PRINT_DBG(shA3.use_count()) 
            << std::endl;

    std::cout << "Ended" << std::endl;
}

