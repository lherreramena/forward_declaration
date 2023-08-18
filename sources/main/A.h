#ifndef D66BDC5C_FA65_4A8B_9712_D8202702BC26
#define D66BDC5C_FA65_4A8B_9712_D8202702BC26

#include <memory>
#include <string>

class B;

class A
{
    std::unique_ptr<B> m_pB;

    public:

    void setB(std::unique_ptr<B> pB);
    std::string str();
};

#endif /* D66BDC5C_FA65_4A8B_9712_D8202702BC26 */
