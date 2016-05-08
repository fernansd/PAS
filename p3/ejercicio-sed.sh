
#!/bin/bash
base="El dispositivo \1, montado en  \6, tiene usados \3 bloques de un total de \2 (porcentaje \6)"
expresion="^([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+)$"
df | sed -nr -e '2,$s/^([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+)$/El dispositivo \1, montado en  \6, tiene usados \3 bloques de un total de \2 (porcentaje \6)/p'
