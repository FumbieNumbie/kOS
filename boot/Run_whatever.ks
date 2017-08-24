set m to core:part:getmodule("kosProcessor").
m:doevent("open terminal").
set terminal:WIDTH to 35.
set terminal:HEIGHT to 21.

set ch to terminal:input:getchar().
set file to lexicon(1,"boot1.ks",
                    2,"boot-mun.ks"


                    ).

set choice to 1.

print file[choice] at (2,5).
if ch = terminal:input:DOWNCURSORONE {
  set choice to choice + 1.
  print file[choice] at (2,5).
}
if ch = terminal:input:UPCURSORONE {
  set choice to choice - 1.
  print file[choice] at (2,5).
}
if ch = terminal:input:RETURN {
  runpath("0:/boot/"+choice).
}
