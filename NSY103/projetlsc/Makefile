CC		= gcc

CFLAGS		= -Wall -Werror -ansi -pedantic
CFLAGS		+= -D_XOPEN_SOURCE=500
CFLAGS		+= -g

RM		= rm -f

EXEC		= myLs

SRCS		= ls.c

OBJS		= $(SRCS:.c=.o)

all:		$(EXEC)

$(EXEC):	$(OBJS)
		$(CC) -o $(EXEC) $(CFLAGS) $(SRCS)

clean:
		$(RM) $(OBJS)

fclean:		clean
		$(RM) $(EXEC) *~

re:		fclean all
