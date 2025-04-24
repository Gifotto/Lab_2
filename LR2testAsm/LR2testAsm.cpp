#include <iostream>
#include <sstream>
#include <string>
using namespace std;

// ЗАДАНИЕ 3
// Проверяет, все ли цифры в числе одинаковые
bool allDigitsSame(const string& number) {
    char firstDigit = number[0];
    for (char digit : number) {
        if (digit != firstDigit)
            return false;
    }
    return true;
}

// Подсчитывает количество чисел с одинаковыми цифрами
int countUniformDigitNumbers(const string& line) {
    stringstream ss(line);
    string num;
    int count = 0;

    while (ss >> num) {
        if (allDigitsSame(num))
            count++;
    }

    return count;
}

int main() {

    //задание 3
    cout << "Введите строку чисел через пробел: ";
    string inLine;
    cin.ignore();
    getline(cin, inLine); // Ввод всей строки чисел через пробел

    int result2 = countUniformDigitNumbers(inLine);
    cout << result2 << endl;

    return 0;
}
