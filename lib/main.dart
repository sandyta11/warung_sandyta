import 'package:flutter/material.dart';

// ============================================================
// THEME CONSTANTS (Blaugrana)
// ============================================================
const Color kBlue = Color(0xFF004D98);
const Color kGarnet = Color(0xFFA50044);
const Color kGold = Color(0xFFEDBB00);
const Color kBg = Color(0xFFF8F9FA);

String formatRupiah(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

// ============================================================
// MODELS
// ============================================================
class MenuItem {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final String description;
  final String imageUrl;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.description,
    required this.imageUrl,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;
  CartItem({required this.item, required this.quantity});
  int get subtotal => item.price * quantity;
}

// ============================================================
// DUMMY DATA
// ============================================================
const List<MenuItem> dummyMenu = [
  MenuItem(
    id: 'm1',
    name: 'Nasi Goreng Spesial',
    category: 'Makanan',
    price: 25000,
    rating: 4.8,
    description:
        'Nasi goreng dengan bumbu rempah khas, telur mata sapi, ayam suwir, '
        'acar, dan kerupuk. Disajikan hangat dengan sambal pilihan.',
    imageUrl:
        'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800',
  ),
  MenuItem(
    id: 'm2',
    name: 'Sate Ayam Madura',
    category: 'Makanan',
    price: 30000,
    rating: 4.7,
    description:
        '10 tusuk sate ayam bakar dengan bumbu kacang khas Madura, '
        'disajikan dengan lontong dan bawang merah.',
    imageUrl:
        'https://images.unsplash.com/photo-1529563021893-cc83c992d75d?w=800',
  ),
  MenuItem(
    id: 'm3',
    name: 'Ayam Bakar',
    category: 'Makanan',
    price: 28000,
    rating: 4.6,
    description:
        'Ayam bakar bumbu kecap manis dengan lalapan segar, sambal terasi, '
        'dan nasi putih hangat.',
    imageUrl:
        'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=800',
  ),
  MenuItem(
    id: 'm4',
    name: 'Es Teh Manis',
    category: 'Minuman',
    price: 5000,
    rating: 4.5,
    description:
        'Teh seduh segar dengan gula pas dan es batu, penyegar di segala suasana.',
    imageUrl:
        'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=800',
  ),
  MenuItem(
    id: 'm5',
    name: 'Es Jeruk Segar',
    category: 'Minuman',
    price: 8000,
    rating: 4.4,
    description: 'Perasan jeruk asli dengan es batu, segar dan kaya vitamin C.',
    imageUrl:
        'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=800',
  ),
  MenuItem(
    id: 'm6',
    name: 'Pisang Goreng Keju',
    category: 'Cemilan',
    price: 15000,
    rating: 4.9,
    description:
        'Pisang goreng krispi dengan taburan keju parut dan susu kental manis.',
    imageUrl:
        'https://images.unsplash.com/photo-1528975604071-b4dc52a2d18c?w=800',
  ),
  MenuItem(
    id: 'm7',
    name: 'Tahu Crispy',
    category: 'Cemilan',
    price: 12000,
    rating: 4.3,
    description: 'Tahu goreng tepung renyah dengan bumbu tabur dan cabai rawit.',
    imageUrl:
        'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800',
  ),
];

// ============================================================
// STATE: CartModel (ChangeNotifier) + InheritedNotifier
// ============================================================
class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get totalQuantity => _items.fold(0, (s, e) => s + e.quantity);
  int get totalPrice => _items.fold(0, (s, e) => s + e.subtotal);
  bool get isEmpty => _items.isEmpty;

  void add(MenuItem item, int qty) {
    final idx = _items.indexWhere((e) => e.item.id == item.id);
    if (idx >= 0) {
      _items[idx].quantity += qty;
    } else {
      _items.add(CartItem(item: item, quantity: qty));
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((e) => e.item.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Provider-like scope. State dipegang di root app (StatefulWidget),
/// sehingga aman saat navigasi & rotasi layar.
class CartScope extends InheritedNotifier<CartModel> {
  const CartScope({super.key, required CartModel cart, required super.child})
      : super(notifier: cart);

  static CartModel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CartScope>()!.notifier!;
}

// ============================================================
// APP
// ============================================================
void main() => runApp(const SanditaApp());

class SanditaApp extends StatefulWidget {
  const SanditaApp({super.key});
  @override
  State<SanditaApp> createState() => _SanditaAppState();
}

class _SanditaAppState extends State<SanditaApp> {
  final CartModel _cart = CartModel();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      cart: _cart,
      child: MaterialApp(
        title: 'Warung Makan Sandita',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: kBg,
          colorScheme: ColorScheme.fromSeed(
            seedColor: kBlue,
            primary: kBlue,
            secondary: kGarnet,
            tertiary: kGold,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: kBlue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

// ============================================================
// SHARED WIDGETS
// ============================================================
BoxDecoration cardDecoration([double radius = 16]) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );

class NetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  const NetImage(this.url, {super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (c, child, progress) => progress == null
          ? child
          : Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: kBlue),
              ),
            ),
      errorBuilder: (c, e, s) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.restaurant, color: kBlue, size: 36),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kGarnet,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ============================================================
// 1. SPLASH SCREEN
// ============================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.room_service, size: 110, color: kGold),
                      SizedBox(height: 20),
                      Text(
                        'Warung Makan\nSandita',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Cita rasa nusantara, semangat Blaugrana',
                          style: TextStyle(color: kGold, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: CircularProgressIndicator(color: kGold),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 2. LOGIN SCREEN
// ============================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  static const _emptyMsg = 'Email dan kata sandi tidak boleh kosong!';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  InputDecoration _dec(String label, IconData icon, {Widget? suffix}) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kBlue),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        errorStyle: const TextStyle(color: Colors.red),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kBlue, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 2)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.room_service, size: 72, color: kBlue),
                    const SizedBox(height: 12),
                    const Text('Selamat Datang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kBlue)),
                    const SizedBox(height: 6),
                    Text('Masuk untuk memesan di Warung Makan Sandita',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _dec('Email', Icons.email_outlined),
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return _emptyMsg;
                        if (!value.contains('@')) {
                          return 'Format email tidak valid (harus mengandung @)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: _dec(
                        'Kata Sandi',
                        Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? _emptyMsg : null,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(label: 'Masuk', onPressed: _submit),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 3. DASHBOARD
// ============================================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [HomeTab(), CartScreen(), ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        selectedItemColor: kBlue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cart.totalQuantity > 0,
              label: Text('${cart.totalQuantity}'),
              backgroundColor: kGarnet,
              child: const Icon(Icons.shopping_cart_rounded),
            ),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  static const _categories = ['Makanan', 'Minuman', 'Cemilan'];
  static const _catIcons = {
    'Makanan': Icons.rice_bowl,
    'Minuman': Icons.local_cafe,
    'Cemilan': Icons.cookie,
  };

  String _query = '';
  String? _category; // null = semua; tap lagi untuk membatalkan

  List<MenuItem> get _filtered => dummyMenu.where((m) {
        final matchCat = _category == null || m.category == _category;
        final matchQ = m.name.toLowerCase().contains(_query.toLowerCase().trim());
        return matchCat && matchQ;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo, Sandita!',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: kBlue)),
                        SizedBox(height: 2),
                        Text('Mau makan apa hari ini?',
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  Container(
                    decoration: cardDecoration(14),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_rounded,
                          color: kBlue),
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                              content: Text('Belum ada notifikasi baru'))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: cardDecoration(14),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: 'Cari menu favoritmu...',
                    prefixIcon: Icon(Icons.search, color: kBlue),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          // Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: _categories.map((c) {
                  final active = _category == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _category = active ? null : c),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: active ? kBlue : Colors.white,
                              border: Border.all(
                                  color: active ? kGold : Colors.grey.shade300,
                                  width: active ? 3 : 1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.07),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3))
                              ],
                            ),
                            child: Icon(_catIcons[c],
                                color: active ? kGold : kBlue),
                          ),
                          const SizedBox(height: 6),
                          Text(c,
                              style: TextStyle(
                                  fontWeight: active
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: active ? kBlue : Colors.black87)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text('Menu Rekomendasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          if (items.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Menu tidak ditemukan',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => MenuCard(item: items[i]),
                  childCount: items.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final MenuItem item;
  const MenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(item: item)),
        ),
        child: Container(
          decoration: cardDecoration(),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(16)),
                child: Hero(
                  tag: 'img_${item.id}',
                  child: NetImage(item.imageUrl, width: 120, height: 120),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.star, color: kGold, size: 18),
                        const SizedBox(width: 4),
                        Text(item.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w500)),
                      ]),
                      const SizedBox(height: 8),
                      Text(formatRupiah(item.price),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kGarnet)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 4. DETAIL SCREEN
// ============================================================
class DetailScreen extends StatefulWidget {
  final MenuItem item;
  const DetailScreen({super.key, required this.item});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final cart = CartScope.of(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: 'img_${item.id}',
                        child: NetImage(item.imageUrl,
                            width: double.infinity, height: 300),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: kBlue),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, -24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: kBg,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: kBlue)),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Text('★',
                                style: TextStyle(color: kGold, fontSize: 20)),
                            const SizedBox(width: 4),
                            Text(item.rating.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 12),
                            Chip(
                              label: Text(item.category),
                              backgroundColor: kBlue.withOpacity(0.1),
                              side: BorderSide.none,
                              visualDensity: VisualDensity.compact,
                            ),
                          ]),
                          const SizedBox(height: 12),
                          Text(item.description,
                              style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black54)),
                          const SizedBox(height: 20),
                          Text(formatRupiah(item.price),
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: kGarnet)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom action bar
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3))
              ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jumlah Porsi',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Row(children: [
                        _CounterButton(
                          icon: Icons.remove,
                          onTap: _qty > 1 ? () => setState(() => _qty--) : null,
                        ),
                        SizedBox(
                          width: 44,
                          child: Text('$_qty',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        _CounterButton(
                          icon: Icons.add,
                          onTap: () => setState(() => _qty++),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label:
                        'Tambah ke Pesanan • ${formatRupiah(item.price * _qty)}',
                    onPressed: () {
                      cart.add(item, _qty);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content:
                              Text('Item berhasil ditambahkan ke keranjang'),
                          backgroundColor: kBlue,
                          behavior: SnackBarBehavior.floating,
                        ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CounterButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? kBlue : Colors.grey.shade300,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ============================================================
// 5. CART SCREEN
// ============================================================
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _checkout(BuildContext context, CartModel cart) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.check_circle, color: kBlue, size: 56),
        title: const Text('Pesanan Berhasil Diterima!',
            textAlign: TextAlign.center),
        content: Text(
          'Total pembayaran ${formatRupiah(cart.totalPrice)}.\n'
          'Pesanan Anda sedang kami siapkan.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kGarnet, foregroundColor: Colors.white),
            onPressed: () {
              cart.clear();
              Navigator.pop(ctx);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang',
            style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 90, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('Keranjang Anda masih kosong',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final ci = items[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: cardDecoration(),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: NetImage(ci.item.imageUrl,
                                  width: 64, height: 64),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ci.item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15)),
                                  const SizedBox(height: 4),
                                  Text('${ci.quantity} porsi',
                                      style: const TextStyle(
                                          color: Colors.black54)),
                                  const SizedBox(height: 4),
                                  Text(formatRupiah(ci.subtotal),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kGarnet)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => cart.remove(ci.item.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, -3))
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(formatRupiah(cart.totalPrice),
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: kBlue)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: 'Checkout Sekarang',
                        onPressed: () => _checkout(context, cart),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ============================================================
// PROFILE TAB (sederhana)
// ============================================================
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: kBlue,
              child: Icon(Icons.person, size: 56, color: kGold),
            ),
            const SizedBox(height: 14),
            const Text('Sandita',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('sandita@warung.id',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  foregroundColor: kGarnet,
                  side: const BorderSide(color: kGarnet)),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (r) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

