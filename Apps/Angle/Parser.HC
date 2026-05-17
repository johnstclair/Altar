class StrBuf {
  U8 *buf;
  I64 len, cap;
};

U0 AppendChar(StrBuf *buf, U8 delim) {
  if (buf->len >= buf->cap) {
    if (buf->cap != 0)
      buf->cap *= 2;
    else 
      buf->cap = 64;
    U8 *tmp_buf = MAlloc(buf->cap);
    MemCpy(tmp_buf, buf->buf, buf->len);
    Free(buf->buf);
    buf->buf = tmp_buf;
  }
  buf->buf[buf->len++] = delim;
  buf->buf[buf->len] = '\0';
}

U0 ToChar(U8* input, I64 *i, U8 delim, Bool save=FALSE, StrBuf *out=NULL) {
  while (input[*i] != delim && input[*i] != '\0') {
    if (save)
      AppendChar(out, input[*i]);
    (*i)++;
  }
}

U8 *GetAttrib(StrBuf *tag, U8* attrib) {
  I64 i = 0;
  while (tag->buf[i] != '\0') {
    U8 *slice = tag->buf + i;
    if (!StrNCmp(slice, attrib, StrLen(attrib))) {
      StrBuf *out = MAlloc(sizeof(StrBuf));
      out->len = 0;
      out->cap = 256;
      out->buf = MAlloc(out->cap);
      i += 2 + StrLen(attrib);
      ToChar(tag->buf, &i, 34, TRUE, out);
      return out->buf;
    } else {
      ToChar(tag->buf, &i, ' ');
      i++;
    }
  }
  return "";
}

public U8 *Parse(U8 *input) {
  I64 i = 0;
  StrBuf *out = MAlloc(sizeof(StrBuf));
  out->len = 0;
  out->cap = 512;
  out->buf = MAlloc(out->cap);
  StrCpy(out->buf, "$WW,1$");

  while (input[i]) {
    StrBuf *tag = MAlloc(sizeof(StrBuf));
    tag->len = 0;
    tag->cap = 64;
    tag->buf = MAlloc(tag->cap);

    if (input[i] == '<') {
      i++;
      ToChar(input, &i, '>', TRUE, tag);      
      i++;

      if ( // check if anchor tag
  (tag->buf[0] == 'a' && tag->buf[1] == ' ') ||
  (tag->buf[0] == 'a' && tag->buf[1] == '>')) {
        U8 *href = GetAttrib(tag, "href");
        StrBuf *nameb = MAlloc(sizeof(StrBuf));
        nameb->len = 0;
        nameb->cap = 128;
        nameb->buf = MAlloc(nameb->cap);
        ToChar(input, &i, '<', TRUE, nameb);
        U8 *link = MAlloc(nameb->len + StrLen(href) + 32);
        StrPrint(link, "$$MA-X,\"%s\",LM=\"\\x01%s\\x02\"$$", nameb->buf, href);
        I64 j = 0;
        while (link[j] != '\0')
          AppendChar(out, link[j++]);
      } else if (!StrNCmp(tag->buf, "div", 3) || 
    !StrNCmp(tag->buf, "p", 1) ||
    !StrNCmp(tag->buf, "span", 4) ||
    !StrNCmp(tag->buf, "h1", 2) ||
    !StrNCmp(tag->buf, "h2", 2)) {
        AppendChar(out, '\n');
      } else if (!StrNCmp(tag->buf, "script", 6) || !StrNCmp(tag->buf, "style", 5)) {
        ToChar(input, &i, '>');
        i++;
      }
    } else {
      AppendChar(out, input[i]);
      i++;
    }
  }
  return out->buf;
}
