dr=dir('./licel/e*');

for i=1:length(dr)
    data=licel_rd(['./licel/' dr(i).name]);
    for j=1:length(data)
        p{j}(:,i)=data{j};
    end
end

%%
z=(1:5000).*.0075;
subplot(2,1,1)
plot(z,p{1})

subplot(2,1,2)
plot(z,p{2})