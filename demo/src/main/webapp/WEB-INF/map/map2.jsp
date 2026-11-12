
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>키워드로 장소검색하고 목록으로 표출하기</title>

    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5e03846a5bae385cef3b2da33124bd8d&libraries=services"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
        }

        body {
            margin: 0;
        }

        .map_wrap {
            position: relative;
            width: 100%;
            height: 500px;
        }

        #map {
            width: 100%;
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .bg_white {
            background: #fff;
        }

        #menu_wrap {
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            width: 250px;
            margin: 10px 0 30px 10px;
            padding: 5px;
            overflow-y: auto;
            background: rgba(255, 255, 255, 0.7);
            z-index: 1;
            font-size: 12px;
            border-radius: 10px;
        }

        #menu_wrap .option {
            text-align: center;
        }

        #menu_wrap .option p {
            margin: 10px 0;
        }

        #menu_wrap .option button {
            margin-left: 5px;
            cursor: pointer;
        }

        #menu_wrap hr {
            display: block;
            height: 1px;
            border: 0;
            border-top: 2px solid #5F5F5F;
            margin: 3px 0;
        }

        #placesList {
            padding: 0;
        }

        #placesList li {
            list-style: none;
        }

        #placesList .item {
            position: relative;
            border-bottom: 1px solid #888;
            overflow: hidden;
            cursor: pointer;
            min-height: 65px;
        }

        #placesList .item span {
            display: block;
            margin-top: 4px;
        }

        #placesList .item h5,
        #placesList .item .info {
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }

        #placesList .item .info {
            padding: 10px 0 10px 55px;
        }

        #placesList .info .gray {
            color: #8a8a8a;
        }

        #placesList .info .jibun {
            padding-left: 26px;
            background: url(https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;
        }

        #placesList .info .tel {
            color: #009900;
        }

        #placesList .item .markerbg {
            float: left;
            position: absolute;
            width: 36px;
            height: 37px;
            margin: 10px 0 0 10px;
            background: url(https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;
        }

        #placesList .item .marker_1 { background-position: 0 -10px; }
        #placesList .item .marker_2 { background-position: 0 -56px; }
        #placesList .item .marker_3 { background-position: 0 -102px; }
        #placesList .item .marker_4 { background-position: 0 -148px; }
        #placesList .item .marker_5 { background-position: 0 -194px; }
        #placesList .item .marker_6 { background-position: 0 -240px; }
        #placesList .item .marker_7 { background-position: 0 -286px; }
        #placesList .item .marker_8 { background-position: 0 -332px; }
        #placesList .item .marker_9 { background-position: 0 -378px; }
        #placesList .item .marker_10 { background-position: 0 -423px; }
        #placesList .item .marker_11 { background-position: 0 -470px; }
        #placesList .item .marker_12 { background-position: 0 -516px; }
        #placesList .item .marker_13 { background-position: 0 -562px; }
        #placesList .item .marker_14 { background-position: 0 -608px; }
        #placesList .item .marker_15 { background-position: 0 -654px; }

        #pagination {
            margin: 10px auto;
            text-align: center;
        }

        #pagination a {
            display: inline-block;
            margin-right: 10px;
            color: #000;
            text-decoration: none;
        }

        #pagination .on {
            font-weight: bold;
            cursor: default;
            color: #777;
        }
    </style>
</head>

<body>

<div id="app">

    <div class="map_wrap">

        <!-- 카카오 지도 -->
        <div id="map"></div>

        <!-- 검색창 및 검색 결과 -->
        <div id="menu_wrap" class="bg_white">

            <div class="option">
                <div>
                    <form @submit.prevent="searchPlaces">
                        키워드 :
                        <input type="text"
                            id="keyword"
                            v-model="keyword"
                            size="15">

                        <button type="submit">검색하기</button>
                    </form>
                </div>
            </div>

            <hr>

            <!-- 검색 결과 목록 -->
            <ul id="placesList"></ul>

            <!-- 페이지 번호 -->
            <div id="pagination"></div>

        </div>

    </div>

</div>

<script>
    const app = Vue.createApp({

        data() {
            return {
                // 검색어
                keyword: '이태원 맛집',

                // 카카오 지도 객체
                map: null,

                // 장소 검색 객체
                ps: null,

                // 인포윈도우 객체
                infowindow: null,

                // 마커 배열
                markers: []
            };
        },

        methods: {

            // 지도 초기화
            fnInit: function () {

                let self = this;

                var mapContainer = document.getElementById('map');

                var mapOption = {
                    center: new kakao.maps.LatLng(
                        37.566826,
                        126.9786567
                    ),
                    level: 3
                };

                // 지도 생성
                self.map = new kakao.maps.Map(
                    mapContainer,
                    mapOption
                );

                // 장소 검색 객체 생성
                self.ps = new kakao.maps.services.Places();

                // 인포윈도우 생성
                self.infowindow = new kakao.maps.InfoWindow({
                    zIndex: 1
                });

                // 초기 검색
                self.searchPlaces();

            },

            // 키워드 검색
            searchPlaces: function () {

                let self = this;

                var keyword = self.keyword;

                if (!keyword.replace(/^\s+|\s+$/g, '')) {
                    alert('키워드를 입력해주세요!');
                    return false;
                }

                // 장소 검색 요청
                self.ps.keywordSearch(
                    keyword,
                    self.placesSearchCB
                );

            },

            // 검색 결과 콜백
            placesSearchCB: function (data, status, pagination) {

                let self = this;

                if (status === kakao.maps.services.Status.OK) {

                    // 검색 결과 목록과 마커 출력
                    self.displayPlaces(data);

                    // 페이지 번호 출력
                    self.displayPagination(pagination);

                } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

                    alert('검색 결과가 존재하지 않습니다.');

                    return;

                } else if (status === kakao.maps.services.Status.ERROR) {

                    alert('검색 결과 중 오류가 발생했습니다.');

                    return;
                }

            },

            // 검색 결과 목록과 마커 출력
            displayPlaces: function (places) {

                let self = this;

                var listEl = document.getElementById('placesList');

                var menuEl = document.getElementById('menu_wrap');

                var fragment = document.createDocumentFragment();

                var bounds = new kakao.maps.LatLngBounds();

                // 기존 검색 결과 삭제
                self.removeAllChildNods(listEl);

                // 기존 마커 제거
                self.removeMarker();

                for (var i = 0; i < places.length; i++) {

                    // 마커 위치
                    var placePosition = new kakao.maps.LatLng(
                        places[i].y,
                        places[i].x
                    );

                    // 마커 생성
                    var marker = self.addMarker(
                        placePosition,
                        i
                    );

                    // 검색 결과 목록 생성
                    var itemEl = self.getListItem(
                        i,
                        places[i]
                    );

                    // 지도 범위 설정
                    bounds.extend(placePosition);

                    // 마커 및 목록 마우스 이벤트
                    (function (marker, title) {

                        kakao.maps.event.addListener(
                            marker,
                            'mouseover',
                            function () {
                                self.displayInfowindow(marker, title);
                            }
                        );

                        kakao.maps.event.addListener(
                            marker,
                            'mouseout',
                            function () {
                                self.infowindow.close();
                            }
                        );

                        itemEl.onmouseover = function () {
                            self.displayInfowindow(marker, title);
                        };

                        itemEl.onmouseout = function () {
                            self.infowindow.close();
                        };

                    })(marker, places[i].place_name);

                    fragment.appendChild(itemEl);

                }

                // 검색 결과 목록에 추가
                listEl.appendChild(fragment);

                // 스크롤 초기화
                menuEl.scrollTop = 0;

                // 지도 범위 재설정
                self.map.setBounds(bounds);

            },

            // 검색 결과 항목 생성
            getListItem: function (index, places) {

                var el = document.createElement('li');

                var itemStr =
                    '<span class="markerbg marker_' + (index + 1) + '"></span>' +
                    '<div class="info">' +
                    '   <h5>' + places.place_name + '</h5>';

                if (places.road_address_name) {

                    itemStr +=
                        '   <span>' + places.road_address_name + '</span>' +
                        '   <span class="jibun gray">' +
                        places.address_name +
                        '</span>';

                } else {

                    itemStr +=
                        '   <span>' + places.address_name + '</span>';

                }

                itemStr +=
                    '   <span class="tel">' +
                    places.phone +
                    '</span>' +
                    '</div>';

                el.innerHTML = itemStr;

                el.className = 'item';

                return el;

            },

            // 마커 생성
            addMarker: function (position, idx, title) {

                let self = this;

                var imageSrc =
                    'https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png';

                var imageSize = new kakao.maps.Size(36, 37);

                var imgOptions = {

                    spriteSize: new kakao.maps.Size(36, 691),

                    spriteOrigin: new kakao.maps.Point(
                        0,
                        (idx * 46) + 10
                    ),

                    offset: new kakao.maps.Point(13, 37)

                };

                var markerImage = new kakao.maps.MarkerImage(
                    imageSrc,
                    imageSize,
                    imgOptions
                );

                var marker = new kakao.maps.Marker({

                    position: position,

                    image: markerImage

                });

                // 지도에 마커 표시
                marker.setMap(self.map);

                // 마커 배열에 추가
                self.markers.push(marker);

                return marker;

            },

            // 기존 마커 제거
            removeMarker: function () {

                let self = this;

                for (var i = 0; i < self.markers.length; i++) {

                    self.markers[i].setMap(null);

                }

                self.markers = [];

            },

            // 페이지 번호 출력
            displayPagination: function (pagination) {

                var paginationEl =
                    document.getElementById('pagination');

                var fragment =
                    document.createDocumentFragment();

                // 기존 페이지 번호 삭제
                while (paginationEl.hasChildNodes()) {

                    paginationEl.removeChild(
                        paginationEl.lastChild
                    );

                }

                for (var i = 1; i <= pagination.last; i++) {

                    var el = document.createElement('a');

                    el.href = '#';

                    el.innerHTML = i;

                    if (i === pagination.current) {

                        el.className = 'on';

                    } else {

                        el.onclick = (function (i) {

                            return function () {

                                pagination.gotoPage(i);

                                return false;

                            };

                        })(i);

                    }

                    fragment.appendChild(el);

                }

                paginationEl.appendChild(fragment);

            },

            // 인포윈도우 출력
            displayInfowindow: function (marker, title) {

                let self = this;

                var content =
                    '<div style="padding:5px;z-index:1;">' +
                    title +
                    '</div>';

                self.infowindow.setContent(content);

                self.infowindow.open(
                    self.map,
                    marker
                );

            },

            // 검색 결과 목록 초기화
            removeAllChildNods: function (el) {

                while (el.hasChildNodes()) {

                    el.removeChild(el.lastChild);

                }

            }

        },

        mounted() {

            // Vue 실행 후 지도 초기화
            let self = this;

            self.fnInit();

        }

    });

    app.mount('#app');

</script>

</body>
</html>
