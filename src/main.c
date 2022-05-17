#include "../library/advanced_calc.h"
#include "../library/simple_calc.h"
#include <stdio.h>


/**
 * @brief Simple main function
 *
 * @return int
 */
int main()
{
  printf("Hello World! I'm alive!\n");

  const int factorA = 5;
  const int factorB = 4;

  printf("--- Using 'Simple Calc'\n");
  printf("'5' plus '4' is |%d|\n", add(factorA, factorB));
  printf("'5' minus '4' is |%d|\n", sub(factorA, factorB));

  printf("--- Using 'Advanced Calc'\n");
  printf("'5' times '4' is |%.2f|\n", mult((float)factorA, (float)factorB));
  printf("'5' div '4' is |%.2f|\n", div((float)factorA, (float)factorB));


  return 0;
}
