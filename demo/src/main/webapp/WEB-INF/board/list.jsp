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
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <table>
                <tr>
                    <!-- <th>선택  </th> -->
                    <th></th> 
                    <th>번호  </th>
                    <th>제목  </th>
                    <th>아이디</th>
                    <th>조회수</th>
                    <th>작성일</th>
                </tr>
                <tr v-for="item in list">
                    <!-- <td><input type="radio" name="board" :value="item.boardNo" v-model="selectItem"></td> -->
                    <td><input type="checkbox" name="board" :value="item.boardNo" v-model="selectItemList"></td>
                    <td>{{item.boardNo}}</td>
                    <td>{{item.title}}</td>
                    <td>{{item.userId}}</td>
                    <td>{{item.cnt}}</td>
                    <td>{{item.cDateTime}}</td>
                </tr>
            </table>
        </div>
        <div>
            <!-- <button @click="fnRemove">삭제</button> -->
            <button @click="fnRemoveAll">삭제</button>
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
                selectItem : "", // 라디오 버튼으로 삭제 할 때
                selectItemList : [] // 체크박스로 삭제할 때
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList : function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "http://localhost:8080/board/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;

                    }
                });
            },
            fnRemove : function(){
                let self = this;
                if(self.selectItem == ""){
                    alert("삭제할 게시글을 선택해주세요.");
                    return;
                }

                if(!confirm("정말 삭제???")){
                    return;
                }

                let param = {
                    boardNo : self.selectItem
                };
                $.ajax({
                    url: "http://localhost:8080/board/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        self.fnList();
                        self.selectItem = "";
                    }
                });
            },
            fnRemoveAll : function(){
                let self = this;
                console.log(self.selectItemList);
                if(self.selectItemList.length == 0){
                    alert("삭제할 게시글을 선택해주세요.");
                    return;
                }

                if(!confirm("정말 삭제???")){
                    return;
                }

                let param = {
                    selectItemList : JSON.stringify(self.selectItemList)
                };
                $.ajax({
                    url: "http://localhost:8080/board/remove-all.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        // alert(data.message);
                        // self.fnList();
                        // self.selectItemList = [];
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