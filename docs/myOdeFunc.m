function dy = myOdeFunc(t, y)
    fprintf('At t = %e \t y(1) = %e \t y(2) = %e\n',t, y(1), y(2));
    
    dy = [y(2); -y(1) - y(2)];
end