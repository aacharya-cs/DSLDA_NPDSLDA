function [] = readurl()


filename = 'aa.txt';
URL = 'http://dl.acm.org/citation.cfm?doid=1099554.1099565&preflayout=flat';
urlwrite(URL,filename)

end

