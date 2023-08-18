#include "A.h"
#include "B.h"

void A::setB(std::unique_ptr<B> pB)
{
    m_pB.reset(pB.release());
}

std::string A::str()
{
    return "class A";
}
