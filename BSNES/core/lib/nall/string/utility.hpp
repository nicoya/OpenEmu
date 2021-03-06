#ifndef NALL_STRING_UTILITY_HPP
#define NALL_STRING_UTILITY_HPP

inline size_t strlcpy(nall::string &dest, const char *src, size_t length) {
  dest.reserve(length);
  return strlcpy(dest(), src, length);
}

inline size_t strlcat(nall::string &dest, const char *src, size_t length) {
  dest.reserve(length);
  return strlcat(dest(), src, length);
}

inline nall::string substr(const char *src, size_t start, size_t length) {
  nall::string dest;
  if(length == 0) {
    //copy entire string
    dest = src + start;
  } else {
    //copy partial string
    strlcpy(dest, src + start, length + 1);
  }
  return dest;
}

/* very simplistic wrappers to return nall::string& instead of char* type */

inline nall::string& strlower(nall::string &str) { strlower(str()); return str; }
inline nall::string& strupper(nall::string &str) { strupper(str()); return str; }
inline nall::string& strtr(nall::string &dest, const char *before, const char *after) { strtr(dest(), before, after); return dest; }
inline nall::string& ltrim(nall::string &str, const char *key) { ltrim(str(), key); return str; }
inline nall::string& rtrim(nall::string &str, const char *key) { rtrim(str(), key); return str; }
inline nall::string& trim (nall::string &str, const char *key) { trim (str(), key); return str; }
inline nall::string& ltrim_once(nall::string &str, const char *key) { ltrim_once(str(), key); return str; }
inline nall::string& rtrim_once(nall::string &str, const char *key) { rtrim_once(str(), key); return str; }
inline nall::string& trim_once (nall::string &str, const char *key) { trim_once (str(), key); return str; }

/* arithmetic <> string */

inline nall::string strhex(uintmax_t value) {
  nall::string temp;
  temp.reserve(strhex(0, value));
  strhex(temp(), value);
  return temp;
}

inline nall::string strsigned(intmax_t value) {
  nall::string temp;
  temp.reserve(strsigned(0, value));
  strsigned(temp(), value);
  return temp;
}

inline nall::string strunsigned(uintmax_t value) {
  nall::string temp;
  temp.reserve(strunsigned(0, value));
  strunsigned(temp(), value);
  return temp;
}

inline nall::string strbin(uintmax_t value) {
  nall::string temp;
  temp.reserve(strbin(0, value));
  strbin(temp(), value);
  return temp;
}

inline nall::string strdouble(double value) {
  nall::string temp;
  temp.reserve(strdouble(0, value));
  strdouble(temp(), value);
  return temp;
}

#endif
