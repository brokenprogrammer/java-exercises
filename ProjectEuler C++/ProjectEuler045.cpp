#include <iostream>
#include <cmath>

/*
    Triangular, pentagonal, and hexagonal
    Problem 45

    Triangle, pentagonal, and hexagonal numbers are generated by the following formulae:

    Triangle	 	Tn=n(n+1)/2	 	1, 3, 6, 10, 15, ...
    Pentagonal	 	Pn=n(3n−1)/2	 	1, 5, 12, 22, 35, ...
    Hexagonal	 	Hn=n(2n−1)	 	1, 6, 15, 28, 45, ...
    It can be verified that T285 = P165 = H143 = 40755.

    Find the next triangle number that is also pentagonal and hexagonal.
*/

bool isPentagonNumber(long long number)
{
    double t = (sqrt(24*number + 1.0) + 1.0) / 6.0;
    return t == (long long)t;
} 

int main () 
{
    bool found = false;
    long long res = 0;
    int n = 143;

    while(!found) 
    {
        n++;
        res = n * (2 * n - 1);

        if (isPentagonNumber(res))
            found = true;
    }

    std::cout << "Answer: " << res;    

    int c = 0;
    std::cin >> c;
    return 0;
}