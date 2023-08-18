#pragma once

#include <memory>
#include <string>

class A;

class B
{
    std::unique_ptr<A> m_pA;

    public:

    void setA(std::unique_ptr<A> pA);
    std::string str();
};
