import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models.dart';
import 'store.dart';

const ink = Color(0xFF173C36);
const paper = Color(0xFFF6F5EF);
const gold = Color(0xFFE8BC61);

class ExplorerApp extends StatelessWidget {
  final ExplorerStore store;
  const ExplorerApp({super.key, required this.store});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: store,
      builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Reading Stations Explorer',
          theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: ink,
              scaffoldBackgroundColor: paper,
              appBarTheme: const AppBarTheme(
                  backgroundColor: paper, foregroundColor: ink),
              inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              cardTheme: CardTheme(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)))),
          home: store.signedIn
              ? ExplorerHome(store: store)
              : WelcomeScreen(store: store)));
}

class WelcomeScreen extends StatefulWidget {
  final ExplorerStore store;
  const WelcomeScreen({super.key, required this.store});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController();
  bool register = false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.store;
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: LayoutBuilder(builder: (context, constraints) {
            final intro =
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.auto_stories_rounded, size: 48, color: gold),
              const SizedBox(height: 30),
              const Text('READING STATIONS EXPLORER',
                  style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: gold)),
              const SizedBox(height: 20),
              const Text('Your next read.\nCloser than you think.',
                  style: TextStyle(
                      fontSize: 46,
                      height: 1.12,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              const Text(
                  'Discover reading materials, find their campus station, and keep a shelf of favourites.',
                  style: TextStyle(
                      fontSize: 18, height: 1.5, color: Colors.white70)),
              const SizedBox(height: 32),
              Text(
                  s.live
                      ? 'CVGC · Campus reading community'
                      : 'Portfolio edition · Sample catalogue',
                  style: const TextStyle(color: Colors.white70)),
            ]);
            final access = Form(
                key: form,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                          s.live
                              ? (register
                                  ? 'Create your account'
                                  : 'Welcome back')
                              : 'Take a look around',
                          style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: ink)),
                      const SizedBox(height: 12),
                      Text(s.live
                          ? 'Sign in to access your campus reading stations.'
                          : 'A working demo with fictional data. Changes are saved on this device. Demo roles are for exploring the interface.'),
                      const SizedBox(height: 26),
                      if (s.live) ...[
                        if (register) field(name, 'Your name'),
                        field(email, 'Email', email: true),
                        field(password, 'Password', password: true),
                        FilledButton(
                            onPressed: s.busy
                                ? null
                                : () async {
                                    if (!form.currentState!.validate()) return;
                                    await s.authenticate(email.text.trim(),
                                        password.text, name.text.trim(),
                                        register: register);
                                  },
                            child: Text(s.busy
                                ? 'Please wait…'
                                : register
                                    ? 'Create account'
                                    : 'Sign in')),
                        TextButton(
                            onPressed: s.busy
                                ? null
                                : () => setState(() => register = !register),
                            child: Text(register
                                ? 'Already have an account? Sign in'
                                : 'New here? Create account')),
                        const Text(
                            'Forgotten your password? Contact your campus administrator for a reset email.',
                            style: TextStyle(fontSize: 12)),
                      ] else ...[
                        FilledButton.icon(
                            onPressed: () => s.enterDemo(),
                            icon: const Icon(Icons.explore_outlined),
                            label: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('Explore as a reader'))),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                            onPressed: () => s.enterDemo(asAdmin: true),
                            icon:
                                const Icon(Icons.admin_panel_settings_outlined),
                            label: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('Explore administration'))),
                        const SizedBox(height: 18),
                        const Text(
                            'No registration. No real student records.\nDemo changes are not shared with other visitors.',
                            style: TextStyle(fontSize: 12, height: 1.5)),
                      ],
                      if (s.error != null)
                        Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(s.error!,
                                style: const TextStyle(color: Colors.red))),
                    ]));
            return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28), color: ink),
                child: constraints.maxWidth > 750
                    ? Row(children: [
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(48),
                                child: intro)),
                        Expanded(
                            child: Container(
                                margin: const EdgeInsets.all(16),
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                    color: paper,
                                    borderRadius: BorderRadius.circular(20)),
                                child: access)),
                      ])
                    : Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(28), child: intro),
                        Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                                color: paper,
                                borderRadius: BorderRadius.circular(24)),
                            child: access)
                      ]));
          })),
    ))));
  }

  Widget field(TextEditingController controller, String label,
          {bool password = false, bool email = false}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
              controller: controller,
              obscureText: password,
              keyboardType:
                  email ? TextInputType.emailAddress : TextInputType.text,
              decoration: InputDecoration(labelText: label),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                if (email &&
                    !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch(value.trim())) return 'Enter a valid email';
                if (password && value.length < 6) {
                  return 'Use at least 6 characters';
                }
                return null;
              }));
}

class ExplorerHome extends StatefulWidget {
  final ExplorerStore store;
  const ExplorerHome({super.key, required this.store});
  @override
  State<ExplorerHome> createState() => _ExplorerHomeState();
}

class _ExplorerHomeState extends State<ExplorerHome> {
  int page = 0;
  String query = '', category = 'All', station = 'All';
  bool availableOnly = false;
  ExplorerStore get s => widget.store;
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  List<NavigationDestination> get destinations => [
        const NavigationDestination(
            icon: Icon(Icons.explore_outlined), label: 'Discover'),
        const NavigationDestination(
            icon: Icon(Icons.location_on_outlined), label: 'Stations'),
        const NavigationDestination(
            icon: Icon(Icons.bookmark_border), label: 'My shelf'),
        const NavigationDestination(
            icon: Icon(Icons.forum_outlined), label: 'Requests'),
        if (s.admin)
          const NavigationDestination(icon: Icon(Icons.tune), label: 'Manage'),
        const NavigationDestination(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ];
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final labels = destinations;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Reading Stations',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            if (s.live)
              IconButton(
                  tooltip: 'Refresh catalogue',
                  onPressed: s.busy ? null : s.refresh,
                  icon: const Icon(Icons.refresh)),
            Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                    child: Chip(
                        label: Text(s.live ? 'Campus' : 'DEMO',
                            style: const TextStyle(fontSize: 11))))),
          ]),
      body: Column(children: [
        if (s.busy) const LinearProgressIndicator(minHeight: 2),
        if (s.error != null)
          MaterialBanner(content: Text(s.error!), actions: [
            TextButton(
                onPressed: () {
                  s.dismissError();
                },
                child: const Text('Dismiss'))
          ]),
        Expanded(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (wide)
            NavigationRail(
                extended: true,
                backgroundColor: paper,
                selectedIndex: page,
                onDestinationSelected: (index) => setState(() => page = index),
                destinations: labels
                    .map((d) => NavigationRailDestination(
                        icon: d.icon, label: Text(d.label)))
                    .toList(),
                trailing: Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                                s.live
                                    ? 'CVGC reading community'
                                    : 'Thesis → working product\nPortfolio edition',
                                style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.6,
                                    color: Colors.black54)))))),
          Expanded(
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1240),
                      child: SingleChildScrollView(
                          padding: EdgeInsets.all(wide ? 32 : 18),
                          child: content())))),
        ])),
      ]),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: page,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              onDestinationSelected: (index) => setState(() => page = index),
              destinations: labels),
    );
  }

  Widget content() {
    if (page == 0) return discover();
    if (page == 1) return stationsPage();
    if (page == 2) return shelf();
    if (page == 3) return requestsPage();
    if (page == 4 && s.admin) return manage();
    return profile();
  }

  Widget heading(String eyebrow, String title, String subtitle,
          {Widget? action}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(eyebrow.toUpperCase(),
                style: const TextStyle(
                    letterSpacing: 2,
                    color: ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w700, color: ink)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(height: 1.5, color: Colors.black54)),
            if (action != null)
              Padding(padding: const EdgeInsets.only(top: 16), child: action),
          ]));
  Widget discover() {
    final categories = [
      'All',
      ...s.books.map((b) => b.category).toSet().toList()..sort()
    ];
    final filtered = s.books
        .where((b) =>
            ('${b.title} ${b.author}'
                .toLowerCase()
                .contains(query.toLowerCase())) &&
            (category == 'All' || b.category == category) &&
            (station == 'All' || b.stationId == station) &&
            (!availableOnly || b.available))
        .toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          margin: const EdgeInsets.only(bottom: 28),
          decoration: BoxDecoration(
              color: ink, borderRadius: BorderRadius.circular(22)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('A CAMPUS FULL OF STORIES',
                style: TextStyle(color: gold, fontSize: 11, letterSpacing: 2)),
            const SizedBox(height: 12),
            const Text('Find something\nworth turning a page for.',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                    color: Colors.white)),
            const SizedBox(height: 18),
            Text(
                '${s.books.length} reading materials  ·  ${s.stations.length} stations  ·  One reading community',
                style: const TextStyle(color: Colors.white70, height: 1.5)),
          ])),
      heading(
          'Explore the collection',
          'A little curiosity goes a long way.',
          s.live
              ? 'Browse your campus catalogue by title, author, category, or station.'
              : 'Illustrative books and stations. Availability does not describe the real CVGC campus.'),
      TextField(
          controller: search,
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
              hintText: 'Search by title or author',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        search.clear();
                        setState(() => query = '');
                      },
                      icon: const Icon(Icons.close)))),
      const SizedBox(height: 16),
      Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .map((c) => ChoiceChip(
                  label: Text(c),
                  selected: category == c,
                  onSelected: (_) => setState(() => category = c)))
              .toList()),
      const SizedBox(height: 12),
      Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
                width: 260,
                child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: s.stations.any((e) => e.id == station)
                        ? station
                        : 'All',
                    decoration:
                        const InputDecoration(labelText: 'Reading station'),
                    items: [
                      const DropdownMenuItem(
                          value: 'All', child: Text('All stations')),
                      ...s.stations.map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name, overflow: TextOverflow.ellipsis)))
                    ],
                    onChanged: (value) => setState(() => station = value!))),
            FilterChip(
                label: const Text('Available now'),
                selected: availableOnly,
                onSelected: (value) => setState(() => availableOnly = value)),
            TextButton(
                onPressed: () => setState(() {
                      query = '';
                      search.clear();
                      category = 'All';
                      station = 'All';
                      availableOnly = false;
                    }),
                child: const Text('Reset filters')),
          ]),
      const SizedBox(height: 24),
      Text('${filtered.length} materials',
          style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      bookGrid(filtered),
    ]);
  }

  Widget bookGrid(List<ReadingBook> books) {
    if (books.isEmpty) {
      return empty('No materials here yet',
          'Try a different search or explore the collection.');
    }
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 850
          ? 3
          : constraints.maxWidth >= 540
              ? 2
              : 1;
      final width = (constraints.maxWidth - (columns - 1) * 16) / columns;
      return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: books
              .map((b) => SizedBox(width: width, child: bookCard(b)))
              .toList());
    });
  }

  Color bookColor(String category) => const [
        Color(0xFFD9E8DF),
        Color(0xFFEDE0C4),
        Color(0xFFDDE5F1),
        Color(0xFFE9DDE4)
      ][category.codeUnits.fold<int>(0, (a, b) => a + b) % 4];
  Widget bookCard(ReadingBook book) => Card(
      margin: EdgeInsets.zero,
      child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => bookDetails(book),
          child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: bookColor(book.category),
                            borderRadius: BorderRadius.circular(12)),
                        child: Stack(children: [
                          const Center(
                              child: Icon(Icons.menu_book_rounded,
                                  size: 60, color: ink)),
                          Positioned(
                              right: 6,
                              top: 6,
                              child: IconButton(
                                  tooltip: s.favourites.contains(book.id)
                                      ? 'Remove from favourites'
                                      : 'Save to favourites',
                                  onPressed: s.busy
                                      ? null
                                      : () => s.toggleFavourite(book.id),
                                  icon: Icon(
                                      s.favourites.contains(book.id)
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: ink)))
                        ])),
                    const SizedBox(height: 16),
                    Text(book.category.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 19,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: ink)),
                    const SizedBox(height: 8),
                    Text(book.author,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 14),
                    Row(children: [
                      const Icon(Icons.location_on_outlined, size: 15),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(s.stationName(book.stationId),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12)))
                    ]),
                    const SizedBox(height: 10),
                    Text(
                        book.available
                            ? '● Available at station'
                            : '○ Currently unavailable',
                        style: TextStyle(
                            fontSize: 12,
                            color: book.available ? ink : Colors.brown)),
                  ]))));
  Future<void> bookDetails(ReadingBook book) => showDialog<void>(
      context: context,
      builder: (dialog) => AlertDialog(
              title: Text(book.title),
              content: SizedBox(
                  width: 460,
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        Text('By ${book.author}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 18),
                        Text(book.description),
                        const SizedBox(height: 18),
                        Text('Station: ${s.stationName(book.stationId)}'),
                        const SizedBox(height: 8),
                        Text(book.available
                            ? 'Available at station'
                            : 'Currently unavailable'),
                        if (book.url.isNotEmpty)
                          Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: OutlinedButton.icon(
                                  onPressed: () => openBook(book.url),
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('Open reading resource'))),
                        const SizedBox(height: 10),
                        const Text(
                            'Availability is catalogue information; this app does not reserve or lend books.',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54)),
                      ]))),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(dialog);
                      requestDialog(
                          title: book.title,
                          author: book.author,
                          missing: true);
                    },
                    child: const Text('Report missing')),
                TextButton(
                    onPressed: () => Navigator.pop(dialog),
                    child: const Text('Close'))
              ]));
  Future<void> openBook(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      message('Only valid HTTPS resources can be opened.');
      return;
    }
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        message('Could not open this resource.');
      }
    } catch (_) {
      message('Could not open this resource.');
    }
  }

  Widget empty(String title, String subtitle) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(38),
      child: Column(children: [
        const Icon(Icons.auto_stories_outlined, size: 42, color: ink),
        const SizedBox(height: 14),
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center)
      ]));
  Widget shelf() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading('Your reading life', 'A shelf of possibilities.',
            'Save interesting materials and come back when you are ready.'),
        bookGrid(s.books.where((b) => s.favourites.contains(b.id)).toList())
      ]);
  Widget stationsPage() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading(
            'Around campus',
            'Find your reading spot.',
            s.live
                ? 'Explore materials grouped by reading station.'
                : 'Sample locations for demonstrating station discovery.'),
        ...s.stations.map((item) => Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.location_on_outlined, color: ink),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(item.name,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: ink)))
                      ]),
                      const SizedBox(height: 10),
                      Text(item.location),
                      const SizedBox(height: 14),
                      Text(
                          '${s.books.where((b) => b.stationId == item.id).length} materials'),
                      TextButton(
                          onPressed: () => setState(() {
                                page = 0;
                                station = item.id;
                                category = 'All';
                                query = '';
                                search.clear();
                                availableOnly = false;
                              }),
                          child: const Text('Explore this station →')),
                      if (s.admin)
                        Wrap(children: [
                          TextButton(
                              onPressed: () => stationDialog(existing: item),
                              child: const Text('Edit station')),
                          TextButton(
                              onPressed: s.busy
                                  ? null
                                  : () async {
                                      if (await confirm('Remove ${item.name}?',
                                          'Stations containing books must be emptied first.')) {
                                        await s.deleteStation(item.id);
                                      }
                                    },
                              child: const Text('Remove'))
                        ]),
                    ])))),
        if (s.stations.isEmpty)
          empty('No stations yet',
              'An administrator can add the first reading station.'),
        if (s.admin)
          FilledButton.icon(
              onPressed: () => stationDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add station')),
      ]);
  Widget requestsPage() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading(
            'Keep the collection growing',
            s.admin ? 'Community requests.' : 'Your requests.',
            'Suggest a reading material or report something missing at a station.',
            action: FilledButton.icon(
                onPressed: () => requestDialog(),
                icon: const Icon(Icons.add),
                label: const Text('New request'))),
        if (s.requests.isEmpty)
          empty('No requests yet',
              'Requests and missing-material reports will appear here.'),
        ...s.requests.reversed.map((r) => Card(
            child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          r.type == 'missing'
                              ? 'MISSING MATERIAL'
                              : 'MATERIAL SUGGESTION',
                          style: const TextStyle(
                              fontSize: 10, letterSpacing: 1.5)),
                      const SizedBox(height: 8),
                      Text(r.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      Text(r.author),
                      const SizedBox(height: 10),
                      Chip(label: Text(r.status)),
                      if (s.admin)
                        Wrap(
                            spacing: 8,
                            children: ['pending', 'resolved', 'declined']
                                .where((v) => v != r.status)
                                .map((v) => TextButton(
                                    onPressed: s.busy
                                        ? null
                                        : () => s.resolveRequest(r, v),
                                    child: Text('Mark $v')))
                                .toList()),
                    ])))),
      ]);
  Widget manage() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading('Administration', 'Care for the collection.',
            'Maintain materials and stations, and respond to community requests.',
            action: Wrap(spacing: 12, runSpacing: 12, children: [
              FilledButton.icon(
                  onPressed: s.stations.isEmpty ? null : () => bookDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add material')),
              OutlinedButton(
                  onPressed: () => stationDialog(),
                  child: const Text('Add station')),
              OutlinedButton(
                  onPressed: exportReport,
                  child: const Text('Copy catalogue report'))
            ])),
        if (s.stations.isEmpty)
          const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text('Add a station before adding materials.')),
        ...s.books.map((book) => Card(
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                          width: 260,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    '${book.author}\n${s.stationName(book.stationId)}',
                                    style: const TextStyle(fontSize: 12))
                              ])),
                      TextButton(
                          onPressed: () => bookDialog(existing: book),
                          child: const Text('Edit')),
                      TextButton(
                          onPressed: s.busy
                              ? null
                              : () async {
                                  if (await confirm(
                                      'Remove this material?', book.title)) {
                                    await s.deleteBook(book.id);
                                  }
                                },
                          child: const Text('Remove')),
                    ])))),
      ]);
  Widget profile() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading(
            'Your account',
            'Hello, ${s.name}.',
            s.live
                ? s.email
                : 'Local demo. Do not enter sensitive personal information.'),
        Card(
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.admin ? 'Administrator' : 'Reader',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                          '${s.favourites.where((id) => s.books.any((b) => b.id == id)).length} saved materials · ${s.requests.length} requests'),
                      const SizedBox(height: 18),
                      OutlinedButton(
                          onPressed: () => nameDialog(),
                          child: const Text('Edit display name')),
                      if (!s.live) ...[
                        const SizedBox(height: 16),
                        TextButton(
                            onPressed: () {
                              s.enterDemo(asAdmin: !s.admin);
                              setState(() => page = 0);
                            },
                            child: Text(s.admin
                                ? 'Switch to demo reader'
                                : 'Switch to demo administrator')),
                        TextButton(
                            onPressed: s.busy
                                ? null
                                : () async {
                                    if (await confirm('Reset the demo?',
                                        'This clears local sample changes, favourites, and requests.')) {
                                      await s.resetDemo();
                                    }
                                  },
                            child: const Text('Reset demo data')),
                      ],
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                          onPressed: s.busy ? null : s.signOut,
                          child: Text(s.live ? 'Sign out' : 'Leave demo')),
                    ]))),
        const SizedBox(height: 24),
        const Text('About this project',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 10),
        const Text(
            'Rebuilt from the Reading Stations Explorer bachelor thesis for Comilla Victoria Government College. This portfolio edition demonstrates a clearer discovery experience and a shared mobile and web application. It is not an official CVGC service.',
            style: TextStyle(height: 1.6)),
      ]);
  Future<void> exportReport() async {
    final lines = [
      'Reading Stations Explorer — catalogue report',
      'Mode: ${s.live ? 'Firebase' : 'Sample demo'}',
      'Materials: ${s.books.length}',
      'Stations: ${s.stations.length}',
      '',
      ...s.books.map((b) =>
          '${b.title} | ${b.author} | ${s.stationName(b.stationId)} | ${b.available ? 'Available' : 'Unavailable'}')
    ];
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
    message('Catalogue report copied to clipboard.');
  }

  void message(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<bool> confirm(String title, String text) async =>
      await showDialog<bool>(
          context: context,
          builder: (d) =>
              AlertDialog(title: Text(title), content: Text(text), actions: [
                TextButton(
                    onPressed: () => Navigator.pop(d, false),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () => Navigator.pop(d, true),
                    child: const Text('Confirm'))
              ])) ??
      false;
  Future<void> nameDialog() async {
    final controller = TextEditingController(text: s.name);
    await showDialog<void>(
        context: context,
        builder: (d) => AlertDialog(
                title: const Text('Display name'),
                content: TextField(
                    controller: controller,
                    maxLength: 80,
                    decoration: const InputDecoration(labelText: 'Name')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(d),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () async {
                        if (controller.text.trim().isEmpty) return;
                        final ok = await s.saveProfile(controller.text.trim());
                        if (ok && d.mounted) Navigator.pop(d);
                      },
                      child: const Text('Save'))
                ]));
  }

  Widget formField(TextEditingController c, String label,
          {int lines = 1, bool optional = false, bool url = false}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: TextFormField(
              controller: c,
              maxLines: lines,
              maxLength: lines > 1 ? 2000 : 300,
              decoration: InputDecoration(labelText: label),
              validator: (v) {
                if (!optional && (v == null || v.trim().isEmpty)) {
                  return 'Please enter $label';
                }
                if (url && v != null && v.isNotEmpty) {
                  final uri = Uri.tryParse(v);
                  if (uri == null ||
                      uri.scheme != 'https' ||
                      uri.host.isEmpty) {
                    return 'Enter a valid HTTPS URL';
                  }
                }
                return null;
              }));
  Future<void> requestDialog(
      {String title = '', String author = '', bool missing = false}) async {
    final t = TextEditingController(text: title),
        a = TextEditingController(text: author);
    final key = GlobalKey<FormState>();
    var type = missing ? 'missing' : 'suggestion';
    await showDialog<void>(
        context: context,
        builder: (d) => StatefulBuilder(
            builder: (d, update) => AlertDialog(
                    title: const Text('Tell us about a material'),
                    content: SizedBox(
                        width: 460,
                        child: Form(
                            key: key,
                            child: SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  DropdownButtonFormField(
                                      value: type,
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'suggestion',
                                            child: Text('Suggest a material')),
                                        DropdownMenuItem(
                                            value: 'missing',
                                            child:
                                                Text('Report missing material'))
                                      ],
                                      onChanged: (v) => update(() => type = v!),
                                      decoration: const InputDecoration(
                                          labelText: 'Request type')),
                                  const SizedBox(height: 16),
                                  formField(t, 'Title'),
                                  formField(a, 'Author / details'),
                                ])))),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(d),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () async {
                            if (!key.currentState!.validate()) return;
                            final ok = await s.submitRequest(
                                t.text.trim(), a.text.trim(), type);
                            if (ok && d.mounted) {
                              Navigator.pop(d);
                              message('Request submitted.');
                            } else if (d.mounted) {
                              message(s.error ?? 'Could not submit request.');
                            }
                          },
                          child: const Text('Submit'))
                    ])));
  }

  Future<void> stationDialog({Station? existing}) async {
    final name = TextEditingController(text: existing?.name),
        location = TextEditingController(text: existing?.location);
    final key = GlobalKey<FormState>();
    await showDialog<void>(
        context: context,
        builder: (d) => AlertDialog(
                title: Text(existing == null
                    ? 'Add reading station'
                    : 'Edit reading station'),
                content: SizedBox(
                    width: 460,
                    child: Form(
                        key: key,
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              formField(name, 'Station name'),
                              formField(location, 'Location')
                            ])))),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(d),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () async {
                        if (!key.currentState!.validate()) return;
                        final ok = await s.saveStation(Station(
                            existing?.id ?? s.newId(),
                            name.text.trim(),
                            location.text.trim()));
                        if (ok && d.mounted) {
                          Navigator.pop(d);
                        } else if (d.mounted) {
                          message(s.error ?? 'Could not save station.');
                        }
                      },
                      child: const Text('Save'))
                ]));
  }

  Future<void> bookDialog({ReadingBook? existing}) async {
    final title = TextEditingController(text: existing?.title),
        author = TextEditingController(text: existing?.author),
        category = TextEditingController(text: existing?.category),
        description = TextEditingController(text: existing?.description),
        url = TextEditingController(text: existing?.url);
    final key = GlobalKey<FormState>();
    var stationId = existing?.stationId ?? s.stations.first.id;
    var available = existing?.available ?? true;
    await showDialog<void>(
        context: context,
        builder: (d) => StatefulBuilder(
            builder: (d, update) => AlertDialog(
                    title: Text(existing == null
                        ? 'Add reading material'
                        : 'Edit reading material'),
                    content: SizedBox(
                        width: 520,
                        child: Form(
                            key: key,
                            child: SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  formField(title, 'Title'),
                                  formField(author, 'Author'),
                                  formField(category, 'Category'),
                                  formField(description, 'Description',
                                      lines: 3),
                                  formField(
                                      url, 'Reading resource URL (optional)',
                                      optional: true, url: true),
                                  DropdownButtonFormField<String>(
                                      value: stationId,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                          labelText: 'Station'),
                                      items: s.stations
                                          .map((e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.name,
                                                  overflow:
                                                      TextOverflow.ellipsis)))
                                          .toList(),
                                      onChanged: (v) =>
                                          update(() => stationId = v!)),
                                  SwitchListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: const Text('Available at station'),
                                      value: available,
                                      onChanged: (v) =>
                                          update(() => available = v)),
                                ])))),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(d),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () async {
                            if (!key.currentState!.validate()) return;
                            final ok = await s.saveBook(ReadingBook(
                                id: existing?.id ?? s.newId(),
                                title: title.text.trim(),
                                author: author.text.trim(),
                                category: category.text.trim(),
                                stationId: stationId,
                                description: description.text.trim(),
                                url: url.text.trim(),
                                available: available));
                            if (ok && d.mounted) {
                              Navigator.pop(d);
                            } else if (d.mounted) {
                              message(s.error ?? 'Could not save material.');
                            }
                          },
                          child: const Text('Save'))
                    ])));
  }
}
