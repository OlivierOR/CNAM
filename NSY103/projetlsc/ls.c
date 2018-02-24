#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define PATH_MAX 4096

static int	size;

typedef struct		s_my_du
{
  char			name[PATH_MAX];
  struct s_my_du	*next;
}			t_du;

void	display_files(t_du **, const char *, char *);
int	is_in_list(t_du **, char *);
void	run_dir(t_du**, const char *, char *);
void	run_dir_rec(t_du **, t_du *, char *);

int		valid_name(const char *name)
{
  if (!strcmp(name, ".") || !strcmp(name, ".."))
    return (0);
  return (1);
}

void		build_path(const char *pathname, char string[], char *entry)
{
  strcpy(string, pathname);
  strcat(string, "/");
  strcat(string, entry);
}

void		check_args(int argc, char *arg)
{
  if (argc != 3)
    {
      fprintf(stderr, "Syntaxe: ./myLs -[L|*] fichier.\n");
      exit(EXIT_FAILURE);
    }
}

void		display_dir(t_du **global_list, const char *pathname, char *opt_one)
{
  printf("%s: \n", pathname);
  display_files(global_list, pathname, opt_one);
  putchar('\n');
}

void		display_files(t_du **global_list, const char *pathname, char *opt_one)
{
  DIR           *dirp;
  struct dirent *entry;
  struct stat	sb;
  char		string[PATH_MAX];
  char		link[PATH_MAX];
  char		path[PATH_MAX];

  memset(link, 0, PATH_MAX);
  memset(string, 0, PATH_MAX);
  if ((dirp = opendir(pathname)) == NULL)
    {
      perror("opendir");
      exit(EXIT_FAILURE);
    }
  while ((entry = readdir(dirp)) != NULL)
    {
      build_path(pathname, string, entry->d_name);
      lstat(string, &sb);
      if (S_ISLNK(sb.st_mode) && (realpath(string, path) != NULL))
	{
	  if (!strcmp(opt_one, "-L"))
	    {
	      printf("%d\t%s\n", (int)sb.st_size, entry->d_name);
	      size += (int)sb.st_size;
	    }
	  else if (is_in_list(global_list, path))
	    continue;
	}
      else if (valid_name(entry->d_name))
	{
	  printf("%d\t%s\n", (int)sb.st_size, entry->d_name);
	  size += (int)sb.st_size;
	}
    }
  closedir(dirp);
}

int		is_in_list(t_du **list, char *string)
{
 t_du		*tmp;

  tmp = *list;
  while (tmp != NULL)
    {
      if (!strcmp(tmp->name, string))
	return (1);
      tmp = tmp->next;
    }
  return (0);
}

void		put_in_list(t_du **list, char string[])
{
  t_du		*tmp;

  if ((tmp = malloc(sizeof(*tmp))) == NULL)
    exit(EXIT_FAILURE);
  strcpy(tmp->name, string);
  tmp->next = *list;
  *list = tmp;
}


void		run_dir_rec(t_du **global_list, t_du *list, char *opt_one)
{
  struct stat	sb;
  t_du		*tmp;

  tmp = list;
  while (tmp != NULL)
    {
      lstat(tmp->name, &sb);
      if (S_ISDIR(sb.st_mode))
	run_dir(global_list, tmp->name, opt_one);
      tmp = tmp->next;
    }
}

void		run_dir(t_du **global_list, const char *pathname, char *opt_one)
{
  struct dirent	*entry;
  DIR		*dirp;
  t_du		*list;
  char		string[PATH_MAX];

  list = NULL;
  display_dir(global_list, pathname, opt_one);
  if ((dirp = opendir(pathname)) == NULL)
    {
      perror("opendir");
      exit(EXIT_FAILURE);
    }
  while ((entry = readdir(dirp)) != NULL)
    {
      if (valid_name(entry->d_name))
	{
	  build_path(pathname, string, entry->d_name);
	  put_in_list(&list, string);
	}
    }
  run_dir_rec(global_list, list, opt_one);
  closedir(dirp);
}

int	       	du_file(char *opt_one, const char *pathname)
{
  t_du		*global_list;
  struct stat	sb;

  global_list = NULL;
  if (stat(pathname, &sb) == -1)
    {
      perror("stat");
      exit(EXIT_FAILURE);
    }
  if(S_ISREG(sb.st_mode))
    {
      size = (int)sb.st_size;
      printf("%d %s\n", size, pathname);
      return (size);
    }
  if(S_ISDIR(sb.st_mode))
    run_dir(&global_list, pathname, opt_one);
  printf("Taille totale:  %d octets\n", size);
  return (size);
}

int	main(int argc, char **argv)
{
  check_args(argc, argv[1]);
  du_file(argv[1], argv[2]);
  return (EXIT_SUCCESS);
}
