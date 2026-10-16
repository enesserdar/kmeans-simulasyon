% 1. Örnek Veri Oluşturma (100 Müşteri, 2 Özellik)
rng(42);
X = [randn(35,2) + 2; randn(35,2) - 2; randn(30,2) + [3, -3]];

% 2. Toolbox Gerektirmeyen Özel K-Means ve WCSS Hesaplama
wcss = zeros(1, 6);

for k = 1:6
    % İlk merkezleri veriden rastgele seç
    idx_init = randperm(size(X,1), k);
    centroids = X(idx_init, :);
    
    % K-Means İterasyonları (Saf MATLAB ile)
    for iter = 1:20
        % Her noktanın merkezlere uzaklığını hesapla (Öklid)
        dists = zeros(size(X,1), k);
        for c = 1:k
            dists(:, c) = sum((X - centroids(c, :)).^2, 2);
        end
        
        % En yakın merkeze ata
        [minDists, clusterIdx] = min(dists, [], 2);
        
        % Merkezleri güncelle
        for c = 1:k
            if any(clusterIdx == c)
                centroids(c, :) = mean(X(clusterIdx == c, :), 1);
            end
        end
    end
    
    % Bu K değeri için Toplam WCSS (Inertia) Hesapla
    wcss(k) = sum(minDists);
end

% 3. Dirsek (Elbow) Grafiğini Çizdirme
figure('Color', 'w');
plot(1:6, wcss, '-o', 'LineWidth', 2, 'MarkerSize', 8, ...
     'MarkerFaceColor', '#D95319', 'Color', '#0072BD');

title('Dirsek (Elbow) Yöntemi ile İdeal Küme Sayısının Belirlenmesi', 'FontSize', 12);
xlabel('Küme Sayısı (K)', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('WCSS (Küme İçi Toplam Hata)', 'FontSize', 11, 'FontWeight', 'bold');
grid on;
xticks(1:6);

% Dirsek Noktasını İşaretleme (K=3)
hold on;
plot(3, wcss(3), 'ro', 'MarkerSize', 14, 'LineWidth', 2.5);
text(3.15, wcss(3) + 10, '\leftarrow Optimum K = 3 (Dirsek Noktası)', ...
     'FontSize', 11, 'FontWeight', 'bold', 'Color', 'r');

% 4. Görseli Kaydet
exportgraphics(gcf, 'dirsek_grafigi.png', 'Resolution', 300);
disp('Grafik başarıyla "dirsek_grafigi.png" adıyla kaydedildi!');
