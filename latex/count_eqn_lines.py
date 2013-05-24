import fileinput

inalign = False
eqn_lines = 0
align_lines = 0
align_count = 0
for line in fileinput.input():
	if 'begin{equation' in line:
		eqn_lines+=1
	elif 'begin{align' in line:
		inalign = True
		align_lines+=1
		align_count+=1
	elif 'end{align' in line:
		inalign=False
	elif '\\' in line and inalign:
		align_lines+=1
print
print
print 'Number of equation envoronments:\t%d' % (eqn_lines)
print 'Number of align environments:\t%d' % (align_count)
print 'Total lines of equations in align envoronments:\t%d' % (align_lines)
print '-'*60
print 'Total lines of equations:\t%d' % (align_lines+eqn_lines)
