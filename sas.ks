set alpha to 5.
until AG10{
  lock steering to heading(90,alpha).
  on AG7 set alpha to alpha+2.5.
  on AG6 set alpha to alpha-2.5.
}
