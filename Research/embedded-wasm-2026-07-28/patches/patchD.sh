#!/bin/bash
# Blocker D workaround: shorthand key path arg -> closure. map(\.x) => map { $0.x }
D="$1/checkouts"; chmod -R u+w "$D" 2>/dev/null
python3 - "$D" <<'PY'
import os,re,sys
rx=re.compile(r'\(\\\.([A-Za-z_][A-Za-z0-9_]*)\)')
n=f=0
for dp,_,fs in os.walk(sys.argv[1]):
    for fn in fs:
        if not fn.endswith(".swift"): continue
        p=os.path.join(dp,fn)
        try: t=open(p,encoding="utf-8").read()
        except: continue
        t2,c=rx.subn(r'{ $0.\1 }',t)
        if c: open(p,"w",encoding="utf-8").write(t2); n+=c; f+=1
print("patchD:",n,"sites in",f,"files")
PY
