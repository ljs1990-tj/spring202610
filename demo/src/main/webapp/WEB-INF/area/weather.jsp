<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <select v-model="si" @change="fnGuList">
                시 : <option value="">:: 선택 ::</option>
                <option :value="item.si" v-for="item in siList">{{item.si}}</option>
            </select>
            <select v-model="gu" @change="fnDongList">
                구 : <option value="">:: 선택 ::</option>
                <option :value="item.gu" v-for="item in guList">{{item.gu}}</option>
            </select>
            <select v-model="dong">
                동 : <option value="">:: 선택 ::</option>
                <option :value="item.dong" v-for="item in dongList">{{item.dong}}</option>
            </select>
        </div>
        
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                siList : [],
                guList : [],
                dongList : [],
                si : "",
                gu : "",
                dong : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnSiList : function () {
                let self = this;
                self.dongList = [];
                self.dong = "";

                let param = {};
                $.ajax({
                    url: "http://localhost:8080/area/si.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.siList = data.siList;
                    }
                });
            },
            fnGuList : function () {
                let self = this;
                self.guList = [];
                self.gu = "";
                self.dongList = [];
                self.dong = "";
                let param = {
                    si : self.si
                };
                $.ajax({
                    url: "http://localhost:8080/area/gu.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.guList = data.guList;
                    }
                });
            },
            fnDongList : function () {
                let self = this;
                self.dongList = [];
                self.dong = "";
                let param = {
                    si : self.si,
                    gu : self.gu
                };
                $.ajax({
                    url: "http://localhost:8080/area/dong.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.dongList = data.dongList;
                    }
                });
            },

            fnGetWeather : function () {
                let self = this;
                let param = {
                    serviceKey : decodeURIComponent(""),
                    pageNo : 1,
                    numOfRows : 1000,
                    dataType : "JSON",
                    base_date : "20261112",
                    base_time : "1600",
                    nx : 55,
                    ny : 125

                };
                $.ajax({
                    url: "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst",
                    dataType: "json",
                    type: "GET",
                    data: param,
                    success: function (data) {
                        console.log(data);
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnSiList();
            self.fnGetWeather();
        }
    });

    app.mount('#app');
</script>