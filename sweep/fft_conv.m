function c = fft_conv(a, b)
%FFT_CONV  Convolution and polynomial multiplication.
%	C = FFT_CONV(A, B) convolves vectors A and B.  The resulting
%	vector is length LENGTH(A)+LENGTH(B)-1.

na = max(size(a));
nb = max(size(b));

if na > nb
    if nb > 1
        a(na+nb-1) = 0;
    end
    c = fftfilt(b, a);
else
    if na > 1
        b(na+nb-1) = 0;
    end
    c = fftfilt(a, b);
end
