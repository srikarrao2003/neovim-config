// Srikar Rao
// Codeforces: https://codeforces.com/profile/srikar_9

#include <bits/stdc++.h>
using namespace std;

/* ================= FAST IO ================= */
#define FAST_IO                                                                          \
    ios::sync_with_stdio(false);                                                         \
    cin.tie(nullptr)

/* ================= TYPES ================= */
using ll = long long;
using ull = unsigned long long;
using ld = long double;

using pii = pair<int, int>;
using pll = pair<ll, ll>;
using vi = vector<int>;
using vll = vector<ll>;

/* ================= CONSTANTS ================= */
const ll INFLL = LLONG_MAX;
const int INF = 1e9;
const ll MOD = 1e9 + 7;
const ld PI = 3.141592653589793238L;

/* ================= MACROS ================= */
#define pb push_back
#define ff first
#define ss second
#define all(x) (x).begin(), (x).end()
#define rall(x) (x).rbegin(), (x).rend()

#define yes cout << "YES\n"
#define no cout << "NO\n"
#define endl '\n'

/* ================= INPUT HELPERS ================= */
template <typename T> void read(vector<T> &v) {
    for (auto &x : v)
        cin >> x;
}

/* ================= OUTPUT HELPERS ================= */
template <typename T> void print(const vector<T> &v) {
    for (auto &x : v)
        cout << x << ' ';
    cout << endl;
}

/* ================= MATH ================= */
ll gcd(ll a, ll b) {
    while (b) {
        a %= b;
        swap(a, b);
    }
    return a;
}

ll lcm(ll a, ll b) {
    return a / gcd(a, b) * b;
}

ll modpow(ll a, ll b, ll m = MOD) {
    ll res = 1;
    while (b) {
        if (b & 1)
            res = (res * a) % m;
        a = (a * a) % m;
        b >>= 1;
    }
    return res;
}

ll modinv(ll a, ll m = MOD) {
    return modpow(a, m - 2, m);
}

/* ================= CHECKS ================= */
bool isPrime(ll n) {
    if (n <= 1)
        return false;
    if (n <= 3)
        return true;
    if (n % 2 == 0 || n % 3 == 0)
        return false;
    for (ll i = 5; i * i <= n; i += 6)
        if (n % i == 0 || n % (i + 2) == 0)
            return false;
    return true;
}

bool isPowerOfTwo(ll x) {
    return x > 0 && (x & (x - 1)) == 0;
}

bool isPerfectSquare(ll x) {
    ll r = sqrtl(x);
    return r * r == x;
}

/* ================= FACTORS ================= */
vector<ll> primeFactors(ll n) {
    vector<ll> f;
    for (ll i = 2; i * i <= n; i++) {
        while (n % i == 0) {
            f.pb(i);
            n /= i;
        }
    }
    if (n > 1)
        f.pb(n);
    return f;
}

vector<ll> allFactors(ll n) {
    vector<ll> f;
    for (ll i = 1; i * i <= n; i++) {
        if (n % i == 0) {
            f.pb(i);
            if (i != n / i)
                f.pb(n / i);
        }
    }
    sort(all(f));
    return f;
}

/* ================= MAIN ================= */
int main() {
    FAST_IO;

    int T;
    cin >> T;
    while (T--) {
        int n;
        cin >> n;
        vector<ll> v(n);
        read(v);
    }
    return 0;
}
