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
        #app {
            width : 800px;
            margin : 30px auto;
            margin-bottom: 300px;
        }
        table {
            width: 750px;
        }

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
        #paging {
            text-align: center;
        }
        #paging a {
            margin-right: 6px;
            font-size: 20px;
            text-decoration: none;
        }
        #paging .active {
            font-weight: bold;
            color : black;
        }
        .table select {
            margin-bottom : 10px;
            width: 80px;
            text-align: center;
        }
        .search {
            text-align: center;
        }
        .search input {
            height: 25px;
        }
        .order {
            margin : 5px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <div class="order">
                <select v-model="category" @change="fnList">
                    <option value="">:: 전체 ::</option>
                    <option v-for="item in categoryList" :value="item.category">{{item.category}}</option>
                </select>
                |
                <label><input @change="fnList" type="radio" v-model="order" value="1">낮은가격순</label>
                <label><input @change="fnList" type="radio" v-model="order" value="2">높은가격순</label>
                <label><input @change="fnList" type="radio" v-model="order" value="3">등록순</label>
            </div>
            <table>
                <tr>
                    <th>제품번호</th>
                    <th>제품명</th>
                    <th>브랜드</th>
                    <th>카테고리</th>
                    <th>가격</th>
                    <th>등록일</th>
                </tr>
                <tr v-for="item in list">
                    <td>{{item.productId}}</td>
                    <td>{{item.productName}}</td>
                    <td>{{item.brand}}</td>
                    <td>{{item.category}}</td>
                    <td>{{item.price}}</td>
                    <td>{{item.releaseDate}}</td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                list : [],
                categoryList : [],
                order : 0,
                category : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList : function () {
                let self = this;
                let param = {
                    order : self.order,
                    category : self.category
                };
                $.ajax({
                    url: "http://localhost:8080/product/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                        self.categoryList = data.categoryList;
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
        }
    });

    app.mount('#app');
</script>