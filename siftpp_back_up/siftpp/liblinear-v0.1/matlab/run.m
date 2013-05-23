[y,xt] = libsvmread('../heart_scale');
model=train(y, xt , '-s 4')
[l,a]=predict(y, xt, model);

