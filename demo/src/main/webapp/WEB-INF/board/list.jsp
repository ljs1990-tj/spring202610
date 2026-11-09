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
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>{{sessionName}}님 환영합니다.</div>
        <div class="table">
            <div class="search">
                검색어 : <input @keyup.enter="fnList" v-model="keyword" placeholder="검색어를 입력해주세요.">
                        <button @click="fnList">검색</button>
            </div>
            <select v-model="pageSize" @change="fnList">
                <option value="5">5개씩</option>
                <option value="10">10개씩</option>
                <option value="15">15개씩</option>
                <option value="20">20개씩</option>
            </select>
            <table>
                <tr>
                    <!-- <th>선택  </th> -->
                    <th><input type="checkbox" @click="fnSelectItem" value="true" v-model="checked"></th> 
                    <th>번호  </th>
                    <th>제목  </th>
                    <th>아이디</th>
                    <th>조회수</th>
                    <th>작성일</th>
                </tr>
                <tr v-for="item in list">
                    <!-- <td><input type="radio" name="board" :value="item.boardNo" v-model="selectItem"></td> -->
                    <td><input @change="fnSelect" type="checkbox" name="board" :value="item.boardNo" v-model="selectItemList"></td>
                    <td>{{item.boardNo}}</td>
                    <td>
                        <a href="javascript:;" @click="fnView(item.boardNo)">{{item.title}}</a>
                    </td>
                    <td>{{item.userId}}</td>
                    <td>{{item.cnt}}</td>
                    <td>{{item.cDateTime}}</td>
                </tr>
            </table>
        </div>
        <div id="paging">
            <a href="javascript:;" v-if="currentPage != 1" @click="currentPage--; fnList();">◀</a>
            <a @click="currentPage = item; fnList();" :class="{active : currentPage == item}" href="javascript:;" v-for="item in idx">{{item}}</a>
            <a href="javascript:;" v-if="currentPage != idx" @click="currentPage++; fnList();">▶</a>
        </div>
        <div>
            <!-- <button @click="fnRemove">삭제</button> -->
            <a href="add.do"><button>글쓰기</button></a>
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
                sessionId : "${sessionId}",
                sessionName : "${sessionName}",
                sessionRole : "${sessionRole}",

                list : [],
                selectItem : "", // 라디오 버튼으로 삭제 할 때
                selectItemList : [], // 체크박스로 삭제할 때
                selectFlg : false,

                checked : false,
                keyword : "", // 검색어

                idx : 1, // 페이징 갯수(최대 페이지 수)
                pageSize : 5, // 한페이지에 출력할 개수
                currentPage : 1, // 현재 페이지
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList : function () {
                let self = this;
                let param = {
                    keyword : self.keyword,
                    limit : self.pageSize,
                    offset : self.pageSize * (self.currentPage - 1)
                };
                $.ajax({
                    url: "http://localhost:8080/board/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                        self.idx = Math.ceil( data.count / self.pageSize );
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
                        alert(data.message);
                        self.fnList();
                        self.selectItemList = [];
                        self.checked = false;
                    }
                });
            },
            fnSelectItem : function(){
                let self = this;
                self.selectItemList = [];

                if(!self.checked){
                    self.list.forEach(map => {
                        self.selectItemList.push(map.boardNo);
                    });
                } 
            },
            fnSelect : function(){
                let self = this;
                self.checked = self.list.length == self.selectItemList.length;
            },
            fnView : function (boardNo){
                let self = this;
                pageChange("view.do", {boardNo : boardNo});
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