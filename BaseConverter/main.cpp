#include <iostream>
using namespace std;

extern "C" char* baseConv(const char* inStr, unsigned int inBase, unsigned int outBase);

int main()
{
	string inStr;
	unsigned int inBase, outBase;
	while (true)
	{
		cin >> inStr >> inBase >> outBase;
		if (inStr == "exit" && inBase == -1)
			break;
		const char* inStrChr = inStr.c_str();
		char* outStrChr = baseConv(inStrChr, inBase, outBase);
		printf("%s\n", outStrChr);
	}
}