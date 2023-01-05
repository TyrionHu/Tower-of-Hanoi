/*
 * @Description: 
 * @Version: 
 * @Author: Tyrion Huu
 * @Date: 2022-12-16 20:40:31
 * @LastEditors: Tyrion Huu
 * @LastEditTime: 2022-12-16 20:51:07
 */
#include <iostream>
#include <string>

bool isDigit(char c)
{
    if(c >= '0' && c <= '9')
    {
        return true;
    }
    else
    {
        return false;
    }
}

int hanoi(int n)
{
    if(n == 1)
    {
        return 1;
    }
    else
    {
        return 2 * hanoi(n - 1) + 1;
    }
}

int main(void)
{
    int N = 0;
    while(1)
    {
        std::cout << "PB21111629" << std::endl;
        if(std::cin)
        {
            int input = std::cin.get();
            std::string str = std::to_string(input);
            if(isDigit(input))
            {
                std::cout << str + " is a decimal digit. " << std::endl; 
                N = input;
                break;
            }
            else
            {
                std::cout << str + " is not a decimal digit. " << std::endl;
            }
        }
    }
    std::cout << std::to_string(hanoi(N)) << std::endl;
    return 0;
}