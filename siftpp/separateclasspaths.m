function [] = separateclasspaths(filename)

fid   = fopen(filename,'r');
count1 = 0;
count2 = 0;
count3 = 0;
count4 = 0;
count5 = 0;
count6 = 0;
count7 = 0;
count8 = 0;

tline = fgetl(fid);
while ischar(tline)
    if(~isempty(regexp(tline,'RockClimbing')))
     count1 = count1 + 1;
     class1{count1} = tline;
    elseif(~isempty(regexp(tline,'badminton')))
     count2 = count2 + 1;
     class2{count2} = tline;
    elseif(~isempty(regexp(tline,'bocce')))
     count3 = count3 + 1;
     class3{count3} = tline;
    elseif(~isempty(regexp(tline,'croquet')))
     count4 = count4 + 1;
     class4{count4} = tline;
    elseif(~isempty(regexp(tline,'polo')))
     count5 = count5 + 1;
     class5{count5} = tline;
    elseif(~isempty(regexp(tline,'Rowing')))
     count6 = count6 + 1;
     class6{count6} = tline;
    elseif(~isempty(regexp(tline,'sailing')))
     count7 = count7 + 1;
     class7{count7} = tline;
    else
     count8 = count8 + 1;
     class8{count8} = tline;
    end
    tline = fgetl(fid);
end

counts  = [count1 count2 count3 count4 count5 count6 count7 count8]
save('UIUCclasses.mat','class1', 'class2', 'class3', 'class4', 'class5', 'class6', 'class7', 'class8');


end


