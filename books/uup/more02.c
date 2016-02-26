/* more02.c - версия 0.2 программы more
*   читает и выводит на экран 24 строки, затем следует несколько
*   специальных команд.
*   особенность версии 0.2: чтение команд из файла /dev/fd/1 */
#include <stdio.h>
#include <stdlib.h>

#define PAGELEN 24
#define LINELEN 512

static void do_more(FILE*);
static int see_more(FILE*);

int
main(int ac, char *av[])
{
    FILE* fp;
    if (ac == 1) {
        do_more(stdin);
    }
    else {
        while (--ac) {
            if ((fp = fopen(*++av, "r")) != NULL) {
                do_more(fp);
                fclose(fp);
            }
            else {
                exit(1);
            }
        }
    }
    return 0;
}


void
do_more(FILE *fp)
/*
* читает PAGELEN строк, затем вызывает see_more() для получения дальнейших инструкций
*/
{
    char line[LINELEN];
    int num_of_lines = 0;
    int reply;
    FILE *fp_tty;

    fp_tty = fopen("/dev/fd/1", "r");
    if (fp_tty == NULL)
        exit(1);
    while (fgets(line, LINELEN, fp)) { /* ввод для more */
        if (num_of_lines == PAGELEN) { /* весь экран? */
            reply = see_more(fp_tty); /* y: ответ пользователя */
            if (reply == 0) /* n: завершить */
                break;
            num_of_lines -= reply;
        }
        if (fputs(line, stdout) == EOF)
            exit(1);
        num_of_lines++;
    }
}

int
see_more(FILE *cmd)
{
    int c;
    printf("\033[7m more? \033[m");
    while ((c = getc(cmd)) != EOF) {
        if (c == 'q')
            return 0;
        if (c == ' ')
            return PAGELEN;
        if (c == '\n')
            return 1;
    }
    return 0;
}
