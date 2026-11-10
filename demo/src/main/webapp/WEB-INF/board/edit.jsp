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
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        #app {
            width : 800px;
            margin : 30px auto;
            margin-bottom: 300px;
        }

        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
            width: 20%;
        }
        td {
            text-align: left;
        }
        td select {
            width: 100px;
            height: 30px;
        }
        td input {
            width: 90%;
            height: 30px;
        }
        .contents{
            width: 750px;
        }
        table {
            width : 100%;
        }
        .editor-area {
            height: 400px;
            padding : 10px 10px 50px 10px;
        }
        .btn-area {
            text-align: center;
            margin-top: 15px;
        }
        .btn-area button{
            height: 30px;
            width: 100px;
            margin: 5px;
            background-color: rgb(186, 236, 237);
            border: 1px solid rgb(106, 187, 188);
            box-shadow: 2px 2px 2px  black;
            cursor: pointer;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="contents">
            <table>
                <tr>
                    <th>게시판</th>
                    <td>
                        <select v-model="kind">
                            <option value="1">공지사항</option>
                            <option value="2">자유게시판</option>
                            <option value="3">문의게시판</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td>
                        <input v-model="title" class="title">
                    </td>
                </tr>
                <tr>
                    <th>첨부파일</th>
                    <td>
                        <input type="file">
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td class="editor-area">
                        <div id="editor"></div>
                    </td>
                </tr>
            </table>
            <div class="btn-area">
                <button @click="fnEdit">수정</button>
                <button>되돌아가기</button>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                boardNo : "${boardNo}",
                kind : "1",
                title : "",
                contents : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnInfo : function () {
                let self = this;
                let param = {
                    boardNo : self.boardNo,
                    option : "EDIT"
                };
                $.ajax({
                    url: "view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.kind = data.info.kind;
                        self.title = data.info.title;
                        self.contents = data.info.contents;
                        self.fnEditor();
                    }
                });
            },
            fnEdit : function () {
                let self = this;
                let param = {
                    boardNo : self.boardNo,
                    kind : self.kind,
                    title : self.title,
                    contents : self.contents
                };
                $.ajax({
                    url: "edit.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("수정 됨!");
                        location.href="list.do";
                    }
                });
            },

            fnEditor : function (){
                let self = this;
                // Quill 에디터 초기화
                var quill = new Quill('#editor', {
                    theme: 'snow',
                    modules: {
                        toolbar: [
                            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                            ['bold', 'italic', 'underline'],
                            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                            ['link', 'image'],
                            [{ 'color': [] }, { 'background': [] }],    
                            ['clean']
                        ]
                    }
                });
                quill.root.innerHTML = self.contents;
                // 에디터 내용이 변경될 때마다 Vue 데이터를 업데이트
                quill.on('text-change', function() {
                    self.contents = quill.root.innerHTML;
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnInfo();
            
        }
    });

    app.mount('#app');
</script>