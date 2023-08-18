#include "A.h"
#include "B.h"

void B::setA(std::unique_ptr<A> pA)
{
    m_pA.reset(pA.release());
}

std::string B::str()
{
    return "class B";
}
