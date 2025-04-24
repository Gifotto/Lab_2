#include <iostream>
#include <sstream>
#include <string>
//#include <Windows.h>
using namespace std;

//ЗАДАНИЕ 1
bool isVowel(char ch) {
    ch = tolower(ch);   // понижение регистра
    return ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u' || ch == 'y';
}

// Функция, которая сравнивает количество гласных и согласных
string checkVowelsAndConsonants(const string& S) {
    int vowels = 0, consonants = 0;

    for (int i = 0; i < S.size(); i++) {
        if (isalpha(S[i])) {
            if (isVowel(S[i]))
                vowels++;
            else
                consonants++;
        }
    }
    if (vowels > consonants)
        return "Да";
    else if (vowels < consonants)
        return "Нет";
    else
        return "Одинаково";
}

//ЗАДАНИЕ 2
//Считает матчи до победы
int countToMatches(int n) {
    int totalMatches = 0;

    while (n > 1) {
        if (n % 2 == 0) {
            // Четное количество команд
            totalMatches += n / 2;
            n = n / 2;
        }
        else {
            // Нечетное количество команд
            totalMatches += (n - 1) / 2;
            n = (n - 1) / 2 + 1;
        }
    }

    return totalMatches;
}


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
    /*SetConsoleCP(1251);
    SetConsoleOutputCP(1251);*/

    //задание 1
    string S;
    cout << "Введите строку (латинскими буквами): ";
    //cin.ignore();
    getline(cin, S); // Ввод строки с пробелами

    string result1 = checkVowelsAndConsonants(S);
    cout << result1 << endl;

    //задание2

    cout << "Введите число: ";
    int n;
    cin >> n;
    cout << countToMatches(n) << endl;

    //задание 3
    cout << "Введите строку чисел через пробел: ";
    string inLine;
    cin.ignore();
    getline(cin, inLine); // Ввод всей строки чисел через пробел

    int result2 = countUniformDigitNumbers(inLine);
    cout << result2 << endl;

    return 0;
}
