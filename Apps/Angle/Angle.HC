#include "::/Adam/Net/Url"
#include "Parser.HC";


U8 g_url_string[128]; 
U8 g_next_url_string[128];
I64 g_url_i = 0;
Bool g_constructing = FALSE;
CDoc *g_doc;

U0 Angle(U8 *filename);
U0 Setup(U8 *filename);

class AppData {
  U8  url_string[64]  format "$$DA-P,A=\"Enter an address   :%s\"$$\n";
};

U0 LoadPage(U8 *url_string) {
  DocClear;
  
  SocketInit();

  U8* response;
  U8* fmt_response;
  I64 len;
  I64 error = UrlGet(url_string, &response, &len);

  DocClear;

  fmt_response = Parse(response);

  if (!error) {
    DocPrint(Fs->put_doc, fmt_response);
  }
  else
    DocPrint(Fs->put_doc, "Something went wrong, try and figure out what this error code means: %d, you got this.");
}

U0 DrawBottomBar(CTask *task, CDC *dc) {
  I64 y1 = task->pix_height - (2 * FONT_HEIGHT);

  dc->color = BLACK;
  GrRect(dc, 0, y1, task->pix_width, 2 * FONT_HEIGHT);

  dc->color = WHITE;
  GrPrint(dc, 0, y1, g_url_string);
}

U0 Setup(U8 *filename) {
  g_doc = DocNew;
  DocDel(Fs->put_doc);
  Fs->put_doc = g_doc;

  if (filename) {
    CDoc *file_doc = DocRead(filename);
    if (file_doc) {
      DocDel(Fs->put_doc);
      Fs->put_doc = file_doc;
    } else {
      DocPrint(Fs->put_doc,
        "$$BG,RED$$$$FD,WHITE$$ Error: File not found. $$BG,DEFAULT$$$$FD,DEFAULT$$\n\n");
    }
  }
}

U0 Angle(U8 *filename="::/Apps/Angle/Home.DD") {
  I64 arg1, arg2, msg_code;
  AppData data;
  MemSet(&data, 0, sizeof(AppData));
  MemSet(g_url_string, 0, 64);

  WinBorder(ON);
  WinMax;

  Setup(filename);

  Fs->draw_it = &DrawBottomBar;

  while (TRUE) {
    msg_code = GetMsg(&arg1, &arg2, 1 << MSG_KEY_DOWN);

    if (msg_code == MSG_KEY_DOWN) {
      if (arg2.u8[0] == SC_F4) {
        Fs->draw_it = NULL;
        if (DocForm(&data)) {
          StrCpy(g_url_string, data.url_string);
          LoadPage(g_url_string);
        }
        Fs->draw_it = &DrawBottomBar;
      } else if (arg1 == '\x01') {
        g_constructing = TRUE;
        g_url_i = 0;
      } else if (arg1 == '\x02' && g_constructing) {
        g_constructing = FALSE;
        g_next_url_string[g_url_i] = '\0';
        if (g_next_url_string[0] != 'h')
          StrPrint(g_url_string,"%s/%s", g_url_string,g_next_url_string);
        else
          StrCpy(g_url_string, g_next_url_string);
        LoadPage(g_url_string);
      } else if (arg1 == CH_ESC) {
        break;
      } else if (g_constructing) {
        g_next_url_string[g_url_i++] = arg1;
      } else {
        DocPutKey(Fs->put_doc, arg1, arg2);
      }
    }
  }

  Fs->draw_it = NULL;
  DocClear;
}
