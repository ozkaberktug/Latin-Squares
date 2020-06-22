void swap(int *a, int *b)
{
    if (*a == *b)
        return;
    *a ^= *b;
    *b ^= *a;
    *a ^= *b;
}

void rev(int *s, int l, int r)
{
    while (l < r)
        swap(&s[l++], &s[r--]);
}

int binary_search(int *s, int l, int r, int key)
{
    int index = -1;
    while (l <= r)
    {
        int mid = l + (r - l) / 2;
        if (s[mid] <= key)
            r = mid - 1;
        else
        {
            l = mid + 1;
            if (index == -1 || s[index] >= s[mid])
                index = mid;
        }
    }
    return index;
}

int nextpermutation(int *s, int n)
{
    int len = n, i = len - 2;
    while (i >= 0 && s[i] >= s[i + 1])
        --i;
    if (i < 0)
        return 0;
    else
    {
        int index = binary_search(s, i + 1, len - 1, s[i]);
        swap(&s[i], &s[index]);
        rev(s, i + 1, len - 1);
        return 1;
    }
}

int fact(int n) { return (n <= 1) ? (1) : (n * fact(n - 1)); }
