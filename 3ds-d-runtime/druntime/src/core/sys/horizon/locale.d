/**
 * D header file for POSIX's <locale.h>.
 *
 * See_Also:  https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/locale.h.html
 * Copyright: D Language Foundation, 2019
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   Mathias 'Geod24' Lang
 * Standards: The Open Group Base Specifications Issue 7, 2018 edition
 * Source:    $(DRUNTIMESRC core/sys/posix/_locale.d)
 */
module core.sys.horizon.locale;

version (Horizon):
extern(C):
nothrow:
@nogc:


struct lconv
{
  char* decimal_point;
  char* thousands_sep;
  char* grouping;
  char* int_curr_symbol;
  char* currency_symbol;
  char* mon_decimal_point;
  char* mon_thousands_sep;
  char* mon_grouping;
  char* positive_sign;
  char* negative_sign;
  char int_frac_digits;
  char frac_digits;
  char p_cs_precedes;
  char p_sep_by_space;
  char n_cs_precedes;
  char n_sep_by_space;
  char p_sign_posn;
  char n_sign_posn;
  char int_n_cs_precedes;
  char int_n_sep_by_space;
  char int_n_sign_posn;
  char int_p_cs_precedes;
  char int_p_sep_by_space;
  char int_p_sign_posn;
}

enum
{
  LC_ALL      = 0,
  LC_COLLATE  = 1,
  LC_CTYPE    = 2,
  LC_MONETARY = 3,
  LC_NUMERIC  = 4,
  LC_TIME     = 5,
  LC_MESSAGES = 6,
}

private struct _locale_t_backing;
alias locale_t = _locale_t_backing*;

enum
{
  LC_ALL_MASK = 1 << LC_ALL,
  LC_COLLATE_MASK = 1 << LC_COLLATE,
  LC_CTYPE_MASK = 1 << LC_CTYPE,
  LC_MONETARY_MASK = 1 << LC_MONETARY,
  LC_NUMERIC_MASK = 1 << LC_NUMERIC,
  LC_TIME_MASK = 1 << LC_TIME,
  LC_MESSAGES_MASK = 1 << LC_MESSAGES,
}

enum LC_GLOBAL_LOCALE = cast(locale_t) -1;

locale_t duplocale(locale_t locale);
void freelocale(locale_t locale);
lconv* localeconv();
locale_t newlocale(int mask, const char* locale, locale_t base);
char* setlocale(int category, const char* locale);
locale_t uselocale(locale_t locale);
