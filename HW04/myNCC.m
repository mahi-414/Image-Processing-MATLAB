function r = myNCC(im1, im2)

avg1 = mean(im1, 'all');
avg2 = mean(im2, 'all');

[rows,cols] = size(im1);

if size(im1)==size(im2)
    sum_num = 0;
    sum_den1 = 0;
    sum_den2 = 0;
    for r=1:rows
        for c=1:cols
            val1 = im1(r,c);
            val2 = im2(r,c);
            num = double((val1-avg1)*(val2-avg2));
            den1 = double((val1-avg1)^2);
            den2 = double((val2-avg2)^2);
            % if (den1 ~= 255 && den1 ~= 0 || den2 ~= 255 && den2 ~= 0)
            %     disp("not 255 and not 0")
            % end
            sum_num = sum_num+num;
            sum_den1 = sum_den1+den1;
            sum_den2 = sum_den2+den2;
        end
    end
    r = double(sum_num)/(sqrt(double(sum_den1))*sqrt(double(sum_den2)));
else
    r=0;
end


end