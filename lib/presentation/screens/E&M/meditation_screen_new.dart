import 'package:flutter/material.dart';

class MeditationScreenNew extends StatelessWidget {
  const MeditationScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1c2b),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF0d1c2b),
              floating: true,
              pinned: true,
              elevation: 0,
              title: const Text(
                "Meditasyon Keşfet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuC9WYDnWoESOBwjPN3V58dgX3mjimzZm5NXmNN4ruaGq6S8RKlOTEXR3Fz6Hd40UoFDsYnMSWTH7umCGCfXnTFX5VbzJX0UrhfFbpi2tw6utLvKp9TfPafMLyWa-JDKbGD_mL4neeufL1NE7bC81_IlITg8LbEBL40r47PdkDuDSZleCIGztO5FJJILeCimK1FOJI8BJDwHQTGKcPs9f1aKDQjMXhkUUB7bm34uWr-VWaL7MPXVQnIsCdkJU2YZVpSzoRpY7XceHAI0"),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Nasıl hissediyorsun? Bir seans ara...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(0xFF1a2634),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTimeFilter("Tümü", true),
                      _buildTimeFilter("5 dk", false),
                      _buildTimeFilter("10 dk", false),
                      _buildTimeFilter("20+ dk", false),
                    ],
                  ),
                ),
              ),
            ),
            _buildSectionHeader("Güne Başlarken", "wb_sunny"),
            _buildMeditationsList(),
            _buildSectionHeader("Gün Arası Mola", "self_improvement"),
            _buildMeditationsList2(),
             _buildSectionHeader("Akşam Gevşemesi", "spa"),
            _buildMeditationsList3(),
            _buildSectionHeader("Gece Uyku", "bedtime"),
            _buildMeditationsList4(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilter(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isActive,
        onSelected: (selected) {},
        backgroundColor: isActive ? const Color(0xFF38bdf8) : const Color(0xFF1a2634),
        labelStyle: TextStyle(
          color: isActive ? const Color(0xFF0d1c2b) : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        shape: StadiumBorder(),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader(String title, String iconName) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  IconData(iconName.codeUnitAt(0), fontFamily: 'MaterialIcons'),
                  color: Colors.yellow[600],
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Text(
              "Tümünü Gör",
              style: TextStyle(color: Color(0xFF38bdf8), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMeditationsList() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildMeditationCard(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuAVy9ZxzUqrt20lQtK2UqXa3Yjv9mxXKWys_g9sUw7yW3Ly7bX6jcl4uQvfrTbOtKLl7DnKnDm32Yo2x_91KzbMudiVRMo1Bv7JTFMsU9IUr4hwg99Gy0RWx_CJ2NE0GzcB9WtsF-8ONa3Kpw4kfx9bdnUEkyQdlFLQlQjfUnPMWgcdocCzePnSXPAwWugDnT9fW2lVZ79yRrhsJaqQCaqgacd2kyVliH14KswkDHhxBB6kICDVUBSRqaJnduTWdnx9q-jm2Z64RKdB",
              "Sabah Enerjisi",
              "Güne pozitif ve zinde bir başlangıç yapın.",
              "5 dk",
              isNew: true,
            ),
            _buildMeditationCard(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuDofUEmNaunTXhyK84O9HKiTIdUYfoALTlgolydprETqDow5GLAwdWagNuxQzAqp4IitvlAjzpemeryMBJJvV4753wvxt5c2TN6KvDFOva3soaHHC7bytYV3ltywQHes60X2M8mupfTzi8SFkFtfIwRsKe7jrDG60QEgmzaYL9ehNVJqxZjs9GkJw2OnOcphs3yoZgrUnCKjxG9XjjxSSSsV57dMAu5RSP1LgoirYujB-ilCVbbiRaszUUfx5VQUg-CCw-V_VGJaYjK",
              "Nefes Farkındalığı",
              "Nefesinize odaklanarak anın tadını çıkarın.",
              "8 dk",
            ),
          ],
        ),
      ),
    );
  }
  
    SliverToBoxAdapter _buildMeditationsList2() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildMeditationCard(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuCRgL_127PvrsSfh-5N_i3zmT6Oni4byBrnc2FG51InpFMpfx3tsIWcgQZQgwV8kYT3SZhuOtveLltStnL-0vspLfOiBUxw3U6L7gyWhcqJ-B2iSrYnEO_zkRjZGtGKWMHd28DdX1TIzgEwz0mUMWqNsgRjNotiFJDkXVauVanJZAZIG4VnVnm--mxVFpjmK8S5aPO_dXZPeMVeqCv9vPjJJAg85V7ef30JiIwA_SK1fcwJTJfa_xFB_KRGjy2lQKtAp7d6ESOHf36o",
              "Sınav Öncesi Odak",
              "Dikkatinizi toplayın ve performansınızı artırın.",
              "10 dk",
              isNew: true,
            ),
            _buildMeditationCard(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuDUryanUfZlfz2_sA9sB8flWEf5j4eAendABTS7AtVNhwKhcM1TD2a8a1BEbNMDCyxd1zn7GNrdWCjlKoM8J4LJQ7vn-p8u9C89J_dVoFasT7-y_W1oVXzTqXuyuoGKmqKBYK1l1Vvog7dB_aprkCMhj3Ggv5C8ER0vDpj6cbQO3A17jGmngfPhs5zG0ipvMQwBf_b-olay6GHtw7PPptAzbIze9yB-nWHB3GgfcaJK8G3rQp3cYQhBTZI66KD2wD3J28mRSwYZ0UC9",
              "Hızlı Yenilenme",
              "Kısa bir mola ile zihninizi tazeleyin.",
              "5 dk",
            ),
          ],
        ),
      ),
    );
  }
  
      SliverToBoxAdapter _buildMeditationsList3() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildMeditationCard(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuAIixm-knrKXufs6b2X_ocl-x7isuy0Sa79j23rY9kwgadv0MLNbraXTn-5vADlnId2FBvAAxWUTh1-990kW4gPd_oI93wIPlT5a49mx0K-mxHlfjIOLJg2NHS2FoVcIBJaoGhlXkYvsip5lJofBSnfgLmUiALkZhnR3_cg6ekZAkFSLhyrhL8v7Spslntg8o4XWXf3NZENb5g08wKWU7yrmjDwh8hye3dxY61NPDuEMTsBkzyD87VUNJ_yG1uHiFfNx0KUqI5SeI6K",
              "Günün Stresini At",
              "Günün yorgunluğunu geride bırakın.",
              "15 dk",
              isNew: true,
            ),
          ],
        ),
      ),
    );
  }
  
        SliverToBoxAdapter _buildMeditationsList4() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildMeditationCard(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuCWaISJuwHfLDhlgjDaIZy1Bwh6sU2kAkazOJWlJjNQi7aFDraUBJyu8e5OUNKNDTPvAABBYFJATEoUALwGEdOcpBwS-o8TmvSTxtiukKXmkKEtwvURIvhLCm1dm_cInWSrCIjXXNFURt1pnfX17ObZLLGM5ciKiqkWrowJnI0ZT3Cdd3GojpiCK01Fs37_5qqGsJDu0Hsbm8jOodxzgxM1bBlZ0fRfyUtePi1svBAZWBIrnzourIwYHMZTlRviCZxRpvTkK-deiIhL",
              "Derin Uykuya Geçiş",
              "Huzurlu bir uyku için rehberli meditasyon.",
              "25 dk",
              isNew: true,
            ),
               _buildMeditationCard(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuBZuQEFqP16ern1Tgh23dF_RL76EULkKNeekrXTkNjad84d2ftiY0ZaJASRX6QL44UfN58hwF1QHLxDCMQVUIRO23MONpl0V3SRRa-3PIY4BmuCKDC7n7UKYG6i2xH5mKM2iw5w2e1d2ks994eXZbj0zWJonWvY-QxdDYvShKTb3iwf9nXPNtKFYaeb6sjr6o6Wu7_bE_JXDCbUcP9Z6U_-aHeFvvqW38AE7NvFGiFUa59oh4F1ROn1rYwOFzQafUC9cTo4I5pUB6Bn",
              "Uyku Hikayeleri",
              "Sakinleştirici seslerle rüyalara dalın.",
              "30 dk",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationCard(
      String imageUrl, String title, String subtitle, String duration,
      {bool isNew = false}) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: isNew
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "YENİ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
